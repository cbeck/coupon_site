class ClippedCouponsController < ApplicationController
  before_filter :login_required
  before_filter :init_search, :only => [:index, :show]
  before_filter :show_search, :only => [:index, :show]
  
  # GET /clipped_coupons
  # GET /clipped_coupons.xml
  def index
    @sort = params[:sort]
    @sort ||= "available_clipped_coupons_by_expiration"
    @clipped_coupons = (current_user.available_clipped_coupons.blank?) ? [] : current_user.send(@sort)       

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clipped_coupons }
    end
  end

  # GET /clipped_coupons/1
  # GET /clipped_coupons/1.xml
  def show
    @clipped_coupon = current_user.clipped_coupons.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clipped_coupon }
    end
  end

  # POST /clipped_coupons
  # POST /clipped_coupons.xml
  def create
    clipped_coupon = ClippedCoupon.find_by_coupon_id_and_user_id(params[:coupon_id], current_user.id)
    @clipped_coupon = clipped_coupon || ClippedCoupon.create(:coupon_id => params[:coupon_id], :user_id => current_user.id)
    #issue with associations proxy forces me to do this. Might want to monkey patch it.
    @clipped_coupon.coupon.clip

    if clipped_coupon
      flash[:notice] = 'You already have this coupon.'      
    else
      flash[:notice] = 'This coupon has been added to your clipped coupons'
    end
  end

  # PUT /clipped_coupons/1
  # PUT /clipped_coupons/1.xml
  def update
    #going to use for favorites functionality - shhh - it's a surprise
    @clipped_coupon = current_user.clipped_coupons.find(params[:id])

    if @clipped_coupon.update_attributes(params[:clipped_coupon])
        flash[:notice] = 'This coupon was added to your favorites.'
    end
  end

  # DELETE /clipped_coupons/1
  # DELETE /clipped_coupons/1.xml
  def destroy
    @clipped_coupon = current_user.clipped_coupons.find(params[:id])
    @clipped_coupon.destroy

    respond_to do |format|
      format.html { redirect_to(user_clipped_coupons_url(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  def print
    conditions = (params[:coupons].length > 1) ? "id IN (#{params[:coupons].join(',')})" : "id = #{params[:coupons]}" unless params[:coupons].blank?
    @coupons = (params[:coupons].blank?) ? [] : Coupon.find(:all, :conditions => conditions) 
  end
  
  def search
    @search = params[:search].downcase
    coupons = current_user.available_clipped_coupons
    tag = Tag.find_by_name(@search)
    @clipped_coupons = coupons.select {|c| c.coupon.business.name.downcase.include?(@search) || ((tag.blank?) ? false : c.coupon.business.tags.include?(tag))}
  end
end
