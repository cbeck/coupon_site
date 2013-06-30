class SiteConfigsController < ApplicationController
  before_filter :sysadmin_required, :add_layout
    
  def index
    @site_configs = SiteConfig.all
  end
  
  def show
    @site_config = SiteConfig.find(params[:id])
  end
  
  # def new
  #   @site_config = SiteConfig.new
  # end
  
  # def create
  #   @site_config = SiteConfig.new(params[:site_config])
  #   if @site_config.save
  #     flash[:notice] = "Successfully created site config."
  #     redirect_to @site_config
  #   else
  #     render :action => 'new'
  #   end
  # end
  
  def edit
    @site_config = SiteConfig.find(params[:id])
  end
  
  def update
    @site_config = SiteConfig.find(params[:id])
    
    SiteConfig.enumeration_model_updates_permitted = true
    if @site_config.update_attributes(params[:site_config])
      flash[:notice] = "Successfully updated site config.  Restarted Server."
      `touch #{RAILS_ROOT}/tmp/restart.txt`
      redirect_to site_configs_path
    else
      render :action => 'edit'
    end
  end
    
  # def destroy
  #   @site_config = SiteConfig.find(params[:id])
  #   @site_config.destroy
  #   flash[:notice] = "Successfully destroyed site config."
  #   redirect_to site_configs_url
  # end
end
