class AdBlocksController < ApplicationController
  before_filter :admin_required
  before_filter :sysadmin_required
  # GET /ad_blocks
  # GET /ad_blocks.xml
  def index
    @ad_blocks = AdBlock.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ad_blocks }
    end
  end

  # GET /ad_blocks/1
  # GET /ad_blocks/1.xml
  def show
    @ad_block = AdBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ad_block }
    end
  end

  # GET /ad_blocks/new
  # GET /ad_blocks/new.xml
  def new
    @ad_block = AdBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ad_block }
    end
  end

  # GET /ad_blocks/1/edit
  def edit
    @ad_block = AdBlock.find(params[:id])
  end

  # POST /ad_blocks
  # POST /ad_blocks.xml
  def create
    @ad_block = AdBlock.new(params[:ad_block])

    respond_to do |format|
      if @ad_block.save
        flash[:notice] = 'AdBlock was successfully created.'
        format.html { redirect_to(@ad_block) }
        format.xml  { render :xml => @ad_block, :status => :created, :location => @ad_block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ad_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ad_blocks/1
  # PUT /ad_blocks/1.xml
  def update
    @ad_block = AdBlock.find(params[:id])

    respond_to do |format|
      if @ad_block.update_attributes(params[:ad_block])
        flash[:notice] = 'AdBlock was successfully updated.'
        format.html { redirect_to(@ad_block) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ad_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_blocks/1
  # DELETE /ad_blocks/1.xml
  def destroy
    @ad_block = AdBlock.find(params[:id])
    @ad_block.destroy

    respond_to do |format|
      format.html { redirect_to(ad_blocks_url) }
      format.xml  { head :ok }
    end
  end
end
