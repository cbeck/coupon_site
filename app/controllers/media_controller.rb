class MediaController < ApplicationController
  caches_page :show
  
  def thumb
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '75x75'}", :type => :flexi
  end

  def small
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '180x180'}", :type => :flexi
  end

  def medium
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '300x300'}", :type => :flexi
  end
  
  def mini
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '160x30'}", :type => :flexi
  end
  
  def show
    @image = Image.find(params[:id])
    # render :inline => "@image", :type => :flexi
    
    respond_to do |format|
      format.html
      format.jpg
      format.xml { render :xml => @image }
    end
  end
end