class SearchController < ApplicationController
  geocode_ip_address
  before_filter :init_search, :except => :create
  before_filter :show_search, :only => [:new, :show]
  protect_from_forgery :except => [:auto_complete_for_search_query] 

  def auto_complete_for_search_query
     # remove these if the solution below performs ok and solves the trick
     #query = params[:search][:query]
     #@tags = Tag.search "#{query}*", :order => :uname
     #@tags = Tag.find :all, :conditions => ["name like ?", "%#{query}%"], :limit => 20, :order => :name
     re = Regexp.new("^#{params[:search][:query]}", "i")
     find_options = { :order => "name ASC" }
     @tags = Tag.find(:all, find_options).select { |tag| tag.name.match re }
     render :partial => 'search/query_examples'
  end

  def show
    @search = Search.new(params)
    begin
      @location = Geokit::Geocoders::GoogleGeocoder.geocode(@search.location)
      raise "geocode failed" unless @location.success?
      logger.info "*** loc = #{@search.location}, radius = #{@search.radius}, query = #{@search.query}"
    rescue
      logger.warn "Geocoder failed for #{@search.location} (using 28277 instead): #{$!}"
      @location = GeoKit::LatLng.new(35.035551, -80.816674)   # zip: 28277
      # @search.radius = 30
    end
    
    unless @search.query.blank?
      @sort = (params[:sort].blank?) ? "distance" : params[:sort]
      order = case @sort
        when "name" then "accounts.name"
        when "latest" then "coupons.id DESC"
        else @sort
      end
      ids = Business.search_for_ids(@search.query, :per_page => 1000)
      @businesses = Business.find :all, :conditions => ["businesses.id in (?)", ids],
        :include => [:account, {:coupons => [{:coupon_template => :account}]}],
        :origin => @location, :within => @search.radius, :order => order
      
      # restrict businesses to current site by way of affiliate group  
      @businesses = filter_businesses(@businesses)

      # @accounts = @businesses.collect(&:account).uniq.paginate(
      #     :page => params[:page], :per_page => @search.pagesize)
      @coupons = @businesses.collect(&:available_coupons).flatten

      @accounts = @coupons.collect{|c| c.coupon_template.account}.uniq.paginate(
          :page => params[:page], :per_page => @search.pagesize)
          
      @coupon_count = @coupons.collect(&:coupon_template).uniq.length
      
      # unless @coupons.blank?
      #   @accounts = @coupons.collect{|c| c.coupon_template.account }.uniq.paginate(
      #     :page => params[:page], :per_page => SiteConfig[:businesses_per_page])
      # end
      
      session[:saved_search] = @search
    else
      @coupons = []
    end
  end

  def new
    @expiring_coupons = current_user.expiring_coupons if logged_in?
  end
  
  def change_home
    @partial = case params[:to]
      when nil, "recent" then "recent"
      when "popular" then "popular"
      else "category"
    end
    if @partial == "category"
      @to = params[:to] 
      @accounts = Account.tagged_with(@to)[0,23]
    end
    
    respond_to do |format|
      format.html { redirect_to new_search_path }
      format.js  
    end
  end
  
  def create
    @search = Search.new(params)
    radius = (@search.radius != Search.default_radius) ? {:radius => @search.radius} : {}
    pagesize = (@search.pagesize != Search.default_pagesize) ? {:pagesize => @search.pagesize} : {}
    opts = radius.merge pagesize
    redirect_to  (@search.location.empty?) ?
      term_search_path(@search.query, opts) :
      loc_search_path(@search.location, @search.query, opts)
  end

private
  def nearby(businesses=[])
    businesses.reject {|b| !@search.nearby(b.location) }
  end

end
