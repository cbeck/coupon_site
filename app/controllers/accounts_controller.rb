class AccountsController < ApplicationController
  before_filter :admin_required, :except => [:details]
  before_filter :sysadmin_required, :only => [:destroy]
  before_filter :init_search, :only => [:details]
  before_filter :show_search, :only => [:details]
  before_filter :add_layout, :except => [:details]
  # GET /accounts
  # GET /accounts.xml
  def index
    @account_search = params[:account_search]
    conditions = ["id in(?)", AffiliateGroup.current.account_ids]
    conditions = ["name like ? and id in(?)", "%#{@account_search}%", AffiliateGroup.current.account_ids] unless @account_search.nil?
    #conditions = ["name like ?", "%#{@account_search}%"] unless @account_search.nil?
    @accounts = Account.paginate(:all, :conditions => conditions, :order => "name ASC", :page => params[:page], :include => :affiliate)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])
    @expiring_coupons = @account.expiring_coupons

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end
  
  def details
    @account = Account.find(params[:id])
    @account.view_all_coupons
  end  

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to new_account_business_path(@account) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def sort_images
    @account = Account.find(params[:id])
    
    unless @account.nil?
      @account.images.each do |image|
        image.position = params['images'].index(image.id.to_s) + 1
        image.save
      end
    end
    render :nothing => true
  end
  
  def remove_image
    image = Image.find params[:id]
    image.destroy
    render :text => 'image removed'
    rescue
      render :text => 'image not removed'
  end
  
  def remove_tagging
     tagging = Tagging.find params[:id]
     tag = tagging.tag
     tagging.destroy
     tag.destroy if tag.taggings.empty?
     render :text => 'tagging removed'
  end
  
end
