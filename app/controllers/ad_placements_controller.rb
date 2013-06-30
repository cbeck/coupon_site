class AdPlacementsController < ApplicationController
  before_filter :admin_required, :add_layout
  # GET /ad_placements
  # GET /ad_placements.xml
  def index
    @ad_placements = AdPlacement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ad_placements }
    end
  end

  # GET /ad_placements/1
  # GET /ad_placements/1.xml
  def show
    @ad_placement = AdPlacement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ad_placement }
    end
  end

  # GET /ad_placements/new
  # GET /ad_placements/new.xml
  def new
    @ad_placement = AdPlacement.new
    @ad_placement.ad_id = params[:ad_id] unless params[:ad_id].blank?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ad_placement }
    end
  end

  # GET /ad_placements/1/edit
  def edit
    @ad_placement = AdPlacement.find(params[:id])
  end

  # POST /ad_placements
  # POST /ad_placements.xml
  def create
    @ad_placement = AdPlacement.new(params[:ad_placement])

    respond_to do |format|
      if @ad_placement.save
        flash[:notice] = 'AdPlacement was successfully created.'
        format.html { redirect_to(@ad_placement) }
        format.xml  { render :xml => @ad_placement, :status => :created, :location => @ad_placement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ad_placement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ad_placements/1
  # PUT /ad_placements/1.xml
  def update
    @ad_placement = AdPlacement.find(params[:id])

    respond_to do |format|
      if @ad_placement.update_attributes(params[:ad_placement])
        flash[:notice] = 'AdPlacement was successfully updated.'
        format.html { redirect_to(@ad_placement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ad_placement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_placements/1
  # DELETE /ad_placements/1.xml
  def destroy
    @ad_placement = AdPlacement.find(params[:id])
    @ad_placement.destroy

    respond_to do |format|
      format.html { redirect_to(ad_placements_url) }
      format.xml  { head :ok }
    end
  end
end
