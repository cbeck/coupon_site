class BusinessesController < ApplicationController
  before_filter :find_account
  before_filter :admin_required, :except => [:details]
  before_filter :sysadmin_required, :only => [:destroy]
  before_filter :init_search, :only => [:details]
  before_filter :show_search, :only => [:details]
  before_filter :add_layout, :except => [:details]

  def index
    @businesses = @account.businesses.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def show
    @business = @account.businesses.find(params[:id])
  end
  
  def details
    @business = @account.businesses.find(params[:id])
    @business.view_all_coupons
  end

  def new
    @business = Business.new
    @business.name = @account.name
    @business.location = Location.new :country => 'US'
    @business.phones << Phone.new(:main => true)
    @business.schedule = Schedule.default
    @business.account = @account
    # @business.people << Person.new(:required => true)
    # @business.email_addresses << EmailAddress.new(:required => true)
  end

  def edit
    @business = @account.businesses.find(params[:id])
  end

  def create
    @business = Business.create(params[:business])
    @business.account = @account
    if @business.save
      if @business.primary?
        @account.businesses.primary.select{|p| p != @business}.each {|op| op.update_attribute(:primary, false)}
      end
      flash[:notice] = 'Business was successfully created.'
      redirect_to(@account)
    else
      render :action => "new"
    end
  end

  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(params[:business])
      flash[:notice] = 'Business was successfully updated.'
      redirect_to([@account, @business])
    else
      render :action => "edit"
    end
  end

  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    redirect_to(@account)
  end
  
  def sort_images
    @business = Business.find(params[:id])

    unless @business.nil?
      @business.images.each do |image|
        image.position = params['images'].index(image.id.to_s) + 1
        image.save
      end
    end
    render :nothing => true
  end

  def remove_person
    person = Person.find params[:id]
    person.destroy 
    render :text => 'person removed'
  end
  
  def remove_phone
    phone = Phone.find params[:id]
    phone.destroy 
    render :text => 'phone removed'
  end
  
  def remove_email
    email = EmailAddress.find params[:id]
    email.destroy 
    render :text => 'email removed'
  end
    
  def remove_website
    website = Website.find params[:id]
    website.destroy 
    render :text => 'website removed'
  end
  
  def remove_tagging
    tagging = Tagging.find params[:id]
    tag = tagging.tag
    tagging.destroy
    tag.destroy if tag.taggings.empty?
    render :text => 'tagging removed'
  end
  
  def remove_image
    image = Image.find params[:id]
    image.destroy
    render :text => 'image removed'
    rescue
      render :text => 'image not removed'
  end
  
  private 
  
  def find_account
    @account = Account.find(params[:account_id])
  end
  
end
