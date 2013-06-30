class AffiliateGroupMembershipsController < ApplicationController
  before_filter :sysadmin_required
  before_filter :add_layout
  # GET /affiliate_group_memberships
  # GET /affiliate_group_memberships.xml
  def index
    @affiliate_group_memberships = AffiliateGroupMembership.find(:all, :order => "affiliate_group_id", :include => [:affiliate, :affiliate_group])
    @affiliate_groups = @affiliate_group_memberships.group_by(&:affiliate_group_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @affiliate_group_memberships }
    end
  end

  # GET /affiliate_group_memberships/1
  # GET /affiliate_group_memberships/1.xml
  def show
    @affiliate_group_membership = AffiliateGroupMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @affiliate_group_membership }
    end
  end

  # GET /affiliate_group_memberships/new
  # GET /affiliate_group_memberships/new.xml
  def new
    @affiliate_group_membership = AffiliateGroupMembership.new
    @affiliate_group_membership.affiliate_group_id = params[:affiliate_group_id] unless params[:affiliate_group_id].blank?
    @affiliate_group_membership.affiliate_id = params[:affiliate_id] unless params[:affiliate_id].blank?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @affiliate_group_membership }
    end
  end

  # GET /affiliate_group_memberships/1/edit
  def edit
    @affiliate_group_membership = AffiliateGroupMembership.find(params[:id])
  end

  # POST /affiliate_group_memberships
  # POST /affiliate_group_memberships.xml
  def create
    @affiliate_group_membership = AffiliateGroupMembership.new(params[:affiliate_group_membership])

    respond_to do |format|
      if @affiliate_group_membership.save
        flash[:notice] = 'AffiliateGroupMembership was successfully created.'
        format.html { redirect_to(affiliate_group_memberships_path) }
        format.xml  { render :xml => @affiliate_group_membership, :status => :created, :location => @affiliate_group_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @affiliate_group_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /affiliate_group_memberships/1
  # PUT /affiliate_group_memberships/1.xml
  def update
    @affiliate_group_membership = AffiliateGroupMembership.find(params[:id])

    respond_to do |format|
      if @affiliate_group_membership.update_attributes(params[:affiliate_group_membership])
        flash[:notice] = 'AffiliateGroupMembership was successfully updated.'
        format.html { redirect_to(@affiliate_group_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @affiliate_group_membership.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def toggle
    @affiliate_group_membership = AffiliateGroupMembership.find(params[:id])
    @affiliate_group_membership.toggle!(:active)
    flash[:notice] = 'Status was updated'
  end

  # DELETE /affiliate_group_memberships/1
  # DELETE /affiliate_group_memberships/1.xml
  def destroy
    @affiliate_group_membership = AffiliateGroupMembership.find(params[:id])
    @affiliate_group_membership.destroy

    respond_to do |format|
      format.html { redirect_to(affiliate_group_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
