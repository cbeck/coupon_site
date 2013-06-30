# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # skip_before_filter :ensure_proper_protocol if RAILS_ENV == "development"

  # before_filter :site_protected if RAILS_ENV == "production"

  before_filter :login_from_cookie, :current_domain, :current_affiliate_group
  before_filter :set_request_environment
  helper_method :current_domain, :current_affiliate_group, :filter_accounts, :filter_businesses
  
  layout "default"
  
  theme :get_theme

  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  
    
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation
  
  def sysadmin_required
    (logged_in? && current_user.sysadmin?) ? true : access_denied
  end
  
  def admin_required
    (logged_in? && (current_user.admin? || current_user.sysadmin?)) ? true : access_denied
  end
  
  def site_protected
    session[:site_key] == SITE_KEY || redirect_to(coming_soon_path)
  end
  
  def init_search
    @search ||= session[:saved_search] || Search.new(:query => '', :location => '')
  end
  
  def show_search
    @show_search = true
  end 
  
  def sort_templates(templates, order)
    sorted_list = case order
      when "business_name" : templates.sort_by {|c| c.account.name }
      when "business_name_desc" : templates.sort_by {|c| c.account.name }.reverse
      when "end_date" : templates.sort_by {|c| [c.expired_on, c.account.name] }
      when "end_date_desc" : templates.sort_by {|c| [-c.expired_on.to_time.to_i, c.account.name] }
      when "start_date" : templates.sort_by {|c| [c.start_on, c.account.name] }
      when "start_date_desc" : templates.sort_by {|c| [-c.start_on.to_time.to_i, c.account.name] }
      when "viewed" : templates.sort_by {|c| c.viewed}.reverse
      when "viewed_desc" : templates.sort_by {|c| c.viewed}
      when "printed" : templates.sort_by {|c| c.printed}.reverse
      when "printed_desc" : templates.sort_by {|c| c.printed}
      when "clipped" : templates.sort_by {|c| c.clipped}.reverse
      when "clipped_desc" : templates.sort_by {|c| c.clipped}
      when "id" : templates.sort_by {|c| c.id}
      when "id_desc" : templates.sort_by {|c| c.id}.reverse
      else templates
    end
    sorted_list
  end
  
  def add_layout
    @add_layout = true
  end
  
  def get_theme
    @current_theme = (@current_domain) ? @current_domain.theme_name : "carolina"
  end
  
  def filter_accounts(accounts)
    accounts.select {|acct| AffiliateGroup.current.accounts.include? acct}
  end
  
  def filter_businesses(businesses)
    businesses.select {|busn| AffiliateGroup.current.accounts.include? busn.account}
  end
  
  private
  
  def current_domain
    return @current_domain if defined?(@current_domain)
    @current_domain = Domain.find_for_request_uri(request)
  end 
  
  def current_affiliate_group
    return @current_affiliate_group if defined?(@current_affiliate_group)
    @current_affiliate_group = current_domain && current_domain.affiliate_group
  end
  
  def set_request_environment
    AffiliateGroup.current = current_affiliate_group
    # logger.info "Current affiliate group is #{@current_affiliate_group.name}" if @current_affiliate_group
    # logger.info "Affilate Group being set is #{current_affiliate_group.name}" if current_affiliate_group
    # logger.info "Current domain is #{@current_domain.url}" if @current_domain
    # logger.info "The affiliate group for this domain is #{current_domain.affiliate_group.name}" if current_domain && current_domain.affiliate_group 
  end
    
  
end
