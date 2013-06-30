class AffiliateGroupsController < ApplicationController
  before_filter :sysadmin_required
  before_filter :add_layout
  
  # GET /affiliate_groups
  # GET /affiliate_groups.xml
  def index
    @affiliate_groups = AffiliateGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @affiliate_groups }
    end
  end

  # GET /affiliate_groups/1
  # GET /affiliate_groups/1.xml
  def show
    @affiliate_group = AffiliateGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @affiliate_group }
    end
  end

  # GET /affiliate_groups/new
  # GET /affiliate_groups/new.xml
  def new
    @affiliate_group = AffiliateGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @affiliate_group }
    end
  end

  # GET /affiliate_groups/1/edit
  def edit
    @affiliate_group = AffiliateGroup.find(params[:id])
  end

  # POST /affiliate_groups
  # POST /affiliate_groups.xml
  def create
    @affiliate_group = AffiliateGroup.new(params[:affiliate_group])

    respond_to do |format|
      if @affiliate_group.save
        flash[:notice] = 'AffiliateGroup was successfully created.'
        format.html { redirect_to(@affiliate_group) }
        format.xml  { render :xml => @affiliate_group, :status => :created, :location => @affiliate_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @affiliate_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /affiliate_groups/1
  # PUT /affiliate_groups/1.xml
  def update
    @affiliate_group = AffiliateGroup.find(params[:id])

    respond_to do |format|
      if @affiliate_group.update_attributes(params[:affiliate_group])
        flash[:notice] = 'AffiliateGroup was successfully updated.'
        format.html { redirect_to(@affiliate_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @affiliate_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliate_groups/1
  # DELETE /affiliate_groups/1.xml
  def destroy
    @affiliate_group = AffiliateGroup.find(params[:id])
    @affiliate_group.destroy

    respond_to do |format|
      format.html { redirect_to(affiliate_groups_url) }
      format.xml  { head :ok }
    end
  end
end
