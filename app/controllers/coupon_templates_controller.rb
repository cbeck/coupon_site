class CouponTemplatesController < ApplicationController
  before_filter :admin_required
  before_filter :load_associations, :only => [:new, :renew, :replace, :edit]
  before_filter :find_account
  before_filter :add_layout
  
  # GET /coupon_templates
  # GET /coupon_templates.xml
  def index
    @coupon_templates = @account.coupon_templates.find(:all, :order => 'expired_on ASC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coupon_templates }
    end
  end

  # GET /coupon_templates/1
  # GET /coupon_templates/1.xml
  def show
    @coupon_template = CouponTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coupon_template }
    end
  end

  # GET /coupon_templates/new
  # GET /coupon_templates/new.xml
  def new
    @coupon_template = CouponTemplate.new
    @coupon_template.account_id = @account.id
    @coupon_template.start_on = Time.now
    @coupon_template.expired_on = SiteConfig[:maximum_coupon_days].to_i.days.from_now

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coupon_template }
    end
  end
  
  # GET /coupon_templates/1/renew
  # GET /coupon_templates/1/renew.xml
  def renew
    @old_coupon_template = CouponTemplate.find(params[:id])
    @coupon_template = @old_coupon_template.clone
    @coupon_template.start_on = Time.now
    @old_coupon_duration = (@old_coupon_template.expired_on - @old_coupon_template.start_on).to_i
    @coupon_template.expired_on = @old_coupon_duration.days.since @coupon_template.start_on.to_time
    
    @old_coupon_template.businesses.each {|business|
      @coupon_template.businesses << business
    }
    
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @coupon_template }
    end
  end
  
  # GET /coupon_templates/1/replace
  # GET /coupon_templates/1/replace.xml
  def replace
     @old_coupon_template = CouponTemplate.find(params[:id])
     @coupon_template = @old_coupon_template.clone
     @coupon_template.start_on = Date.today if @old_coupon_template.start_on < Date.today
     
     @old_coupon_template.businesses.each {|business|
      @coupon_template.businesses << business
     }

     respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @coupon_template }
     end
  end

  # GET /coupon_templates/1/edit
  def edit
    @coupon_template = CouponTemplate.find(params[:id])
  end

  # POST /coupon_templates
  # POST /coupon_templates.xml
  def create
    @coupon_template = CouponTemplate.new(params[:coupon_template])
    unless params[:old_coupon_template].blank?
      @old_coupon_template = CouponTemplate.find(params[:old_coupon_template]) 
      @coupon_template.original = (@old_coupon_template.original.blank?) ? @old_coupon_template : @old_coupon_template.original 
    end
    
    success = false
    CouponTemplate.transaction do
      @coupon_template.offer_values = (params[:offer_values].blank?) ? nil : params[:offer_values].join(',')
      success = @coupon_template.save
      if success
        params[:business_ids].each do |business|
        Coupon.create(:coupon_template_id => @coupon_template.id, :business_id => business)
        end unless params[:business_ids].blank? 
      end
      if @old_coupon_template && success
        @old_coupon_template.update_attribute(:expired_on, 1.days.until(Time.now)) #expire it immediately (which means yesterday), and bypass max day check
      end
    end

    respond_to do |format|
      if success
        flash[:notice] = "#{@coupon_template.name} was successfully created."
        flash[:notice] += ' The old coupon was also expired immediately.' if @old_coupon_template
        format.html { redirect_to([@account, @coupon_template]) }
        format.xml  { render :xml => @coupon_template, :status => :created, :location => [@account, @coupon_template] }
      else
        flash[:notice] = 'There was a problem creating this Coupon Template.'
        load_associations
        format.html { render :action => "new" }
        format.xml  { render :xml => @coupon_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coupon_templates/1
  # PUT /coupon_templates/1.xml
  def update
    @coupon_template = CouponTemplate.find(params[:id])
    success = false
    CouponTemplate.transaction do
      if params[:business_ids].blank?
        @coupon_template.coupons.delete_all
      else      
        params[:business_ids].each do |business|
          Coupon.find_or_create_by_coupon_template_id_and_business_id(:coupon_template_id => @coupon_template.id, :business_id => business.id)
        end
      end 
      
      offer_values = (params[:offer_values].blank?) ? nil : params[:offer_values].join(',')
      params[:coupon_template][:offer_values] = offer_values
      success = @coupon_template.update_attributes(params[:coupon_template])
    end
    
    respond_to do |format|
      if success        
        flash[:notice] = 'CouponTemplate was successfully updated.'
        format.html { redirect_to([@account, @coupon_template]) }
        format.xml  { head :ok }
      else
        load_associations
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coupon_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coupon_templates/1
  # DELETE /coupon_templates/1.xml
  def destroy
    @coupon_template = CouponTemplate.find(params[:id])
    @coupon_template.destroy

    respond_to do |format|
      format.html { redirect_to(account_coupon_templates_url(@account)) }
      format.xml  { head :ok }
    end
  end
  
  def remove_info_box
    info_box = InfoBox.find params[:id]
    info_box.destroy 
    render :text => 'info box removed'
  end
  
  def remove_coupon_limitation
    limit = CouponLimitation.find params[:id]
    limit.destroy 
    render :text => 'limitation removed'
  end
  
  def offer_inputs
    @offer = Offer.find(params[:offer_id])
    template = CouponTemplate.find(params[:id]) unless params[:id] == "-1"
    @offer_values = template.offer_values unless template.blank?
  end
  
  
  private 
  
  def load_associations
    @offers = Offer.find(:all, :order => 'name ASC')
    @limitations = Limitation.all
  end
  
  def find_account
    @account = Account.find(params[:account_id])
  end
  
end
