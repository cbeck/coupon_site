class SiteController < ApplicationController
  before_filter :admin_required, :only => [:admin]
  skip_before_filter :site_protected, :only => [:coming_soon, :site_login]
  before_filter :init_search, :except => [:admin, :maintenance, :maintenance_youtube, :coming_soon, :site_login]
  before_filter :show_search, :except => [:admin, :maintenance, :maintenance_youtube, :coming_soon, :site_login]
  
  # auto_complete_for :tag, :name
  
  def index
  end

  def about
  end
  
  def admin
    @add_layout = true
    @title = 'Site Administration'
    @active_coupons = CouponTemplate.active || []
    @accounts = CouponTemplate.active_accounts || []
    @expiring = CouponTemplate.expiring || []
    
    @active_sort = params[:active_sort] || "business_name"
    @active_coupons = sort_templates(@active_coupons, @active_sort)
    
    @expiring_sort = params[:expiring_sort] || "end_date"
    @expiring = sort_templates(@expiring, @expiring_sort)
   
  end
  
  def maintenance
    render :layout => false
  end
  
  def maintenance_youtube
    render :layout => false
  end
  
  def coming_soon
    session[:site_key] = nil
    render :layout => false
  end
  
  def site_login
    if params[:site][:password] == 'msdemo'
      session[:site_key] = SITE_KEY
      redirect_to home_path
    else
      render :action => :coming_soon, :layout => false
    end
  end
  
  
end
