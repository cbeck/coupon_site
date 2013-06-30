class CouponsController < ApplicationController
  before_filter :admin_required, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :init_search, :only => :show
  before_filter :show_search, :only => :show
  
  # GET /coupons
  # GET /coupons.xml
  def index
    @coupons = Coupon.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.xml
  def show
    @coupon = Coupon.find(params[:id])
    @include_map = true
    @clipped_coupon = (params[:clipped_coupon].blank?) ? nil : ClippedCoupon.find(params[:clipped_coupon])

    respond_to do |format|
      format.html { 
        @print = true 
        @coupon.print
      }
      format.js {
        @coupon.view
        render :partial => "coupons/coupon", :object => @coupon, :locals => {:clipped_coupon => @clipped_coupon}
      }
      format.xml  { render :xml => @coupon }
    end
  end

  # GET /coupons/new
  # GET /coupons/new.xml
  def new
    @coupon = Coupon.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  # POST /coupons
  # POST /coupons.xml
  def create
    @coupon = Coupon.new(params[:coupon])

    respond_to do |format|
      if @coupon.save
        flash[:notice] = 'Coupon was successfully created.'
        format.html { redirect_to(@coupon) }
        format.xml  { render :xml => @coupon, :status => :created, :location => @coupon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.xml
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(params[:coupon])
        flash[:notice] = 'Coupon was successfully updated.'
        format.html { redirect_to(@coupon) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.xml
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to(coupons_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /coupons/1/business
  def business
    store_location
    # This is a little backwards, because the id is actually the business. 
    # I chose to put it here because we have no other exposed resources for business, and didn't want to open any.
    # The intent of this function is to show all of the coupons for a business, along with other business details.
    @business = Business.find(params[:id])
    @coupons = @business.available_coupons
    logger.info @coupons.inspect
  end
  

end
