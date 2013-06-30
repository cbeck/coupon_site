class LimitationsController < ApplicationController
  before_filter :admin_required
  before_filter :add_layout

  # GET /limitations
  # GET /limitations.xml
  def index
    @limitations = Limitation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @limitations }
    end
  end

  # GET /limitations/1
  # GET /limitations/1.xml
  def show
    @limitation = Limitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @limitation }
    end
  end

  # GET /limitations/new
  # GET /limitations/new.xml
  def new
    @limitation = Limitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @limitation }
    end
  end

  # GET /limitations/1/edit
  def edit
    @limitation = Limitation.find(params[:id])
  end

  # POST /limitations
  # POST /limitations.xml
  def create
    @limitation = Limitation.new(params[:limitation])

    respond_to do |format|
      if @limitation.save
        flash[:notice] = 'Limitation was successfully created.'
        format.html { redirect_to(@limitation) }
        format.xml  { render :xml => @limitation, :status => :created, :location => @limitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @limitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /limitations/1
  # PUT /limitations/1.xml
  def update
    @limitation = Limitation.find(params[:id])

    respond_to do |format|
      if @limitation.update_attributes(params[:limitation])
        flash[:notice] = 'Limitation was successfully updated.'
        format.html { redirect_to(@limitation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @limitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /limitations/1
  # DELETE /limitations/1.xml
  def destroy
    @limitation = Limitation.find(params[:id])
    @limitation.destroy

    respond_to do |format|
      format.html { redirect_to(limitations_url) }
      format.xml  { head :ok }
    end
  end
end
