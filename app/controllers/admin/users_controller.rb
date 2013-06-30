class Admin::UsersController < ApplicationController
  before_filter :login_required, :admin_required, :add_layout
  before_filter :find_user, :except => [:index, :new, :create]
  
  def index
    @users = (current_user.sysadmin?) ? 
      User.paginate(:page => params[:page], :order => 'created_at DESC') :
      current_user.affiliate_group.users.paginate(:page => params[:page], :order => 'created_at DESC')
    flash[:notice] = 'Sorry, but there are no users assigned to this group.' if @users.blank?
    @users
  end
  
  # GET /admin_users/1
  # GET /admin_users/1.xml
  def show
  end


  # GET /admin_users/1/edit
  def edit
  end


  # PUT /admin_users/1
  # PUT /admin_users/1.xml
  def update
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if @user.admin? && !@user.affiliate_group
          @user.affiliate_group = @current_affiliate_group
        end
        @user.save
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to admin_users_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.admin? && !@user.affiliate_group
      @user.affiliate_group = @current_affiliate_group
    end
    @user.affiliate_groups << @current_affiliate_group
    success = @user && @user.valid?
    if success
      @user.register!
      @user.activate! 
    end
    
    if success && @user.errors.empty?
      flash[:notice] = "User added"
      redirect_to admin_users_path    
    else
      flash[:error]  = "There was a problem setting up that user."
      render :action => 'new' 
    end
    
  end

  def suspend
    @user.suspend! 
    redirect_to admin_users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to admin_users_path
  end

  def destroy
    @user.delete!
    redirect_to admin_users_path
  end

  def purge
    @user.destroy
    redirect_to admin_users_path
  end
  
 

protected
  def find_user
    @user = User.find(params[:id])
  end
  
  
end
