class UsersController < ApplicationController
  before_filter :login_required, :only => [:myaccount, :edit, :update]
  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:index, :suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :add_layout
  
  
  def myaccount
    @user = current_user
    @expiring_coupons = current_user.expiring_coupons
    @recently_clipped = current_user.recently_clipped
  end
  
  def edit
    @user = current_user
  end

  # render new.rhtml
  def new
    logger.info ">>> #{session.inspect}"
    @user = User.new
    # @user.location = Location.new
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to myaccount_path
    else
      render :action => 'edit'
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.affiliate_groups << @current_affiliate_group
    success = @user && @user.valid?
    if success
      @user.register!
      @user.activate! 
      self.current_user = @user
    end
    
    if success && @user.errors.empty?
      flash[:notice] = "Thanks for signing up!"
      unless params[:coupon_id].blank?
        clipped = ClippedCoupon.create(:coupon_id => params[:coupon_id], :user_id => @user)
        clipped.coupon.clip
        flash[:notice] += " Your coupon has been added to your clipped coupons."
      end
      redirect_back_or_default('/')      
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new' 
    end
    
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def change_password
    @user = current_user
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  def reset_password
    self.current_user = User.find_by_password_reset_code(params[:password_reset_code])
    flash[:notice] = "You must now change your password!"
    redirect_to(change_password_url)

    # if logged_in? && !current_user.activated?
    #   current_user.reset_password
    #   flash[:notice] = "Signup complete!"
    # end
    # redirect_back_or_default('/')
  end
  
  def initiate_reset
    if reset_attempt <= 300
      q = params[:email]
      user = User.find_by_email(q)
      if user.nil?
        flash[:notice] = "User #{q} was not found.  (#{reset_attempt.ordinalize} reset attempt)"
        redirect_to(forgot_password_path)
      else
        user.forgot_password
        flash[:notice] = "An activation link has been sent to #{user.email}."
        redirect_to(login_path)
      end
    else
      flash[:notice] = "Too many reset attempts"
      redirect_to(signup_path)
    end
  end

protected
  def find_user
    @user = User.find(params[:id])
  end
  
  # track the number of reset attempts in a session variable
  def reset_attempt
    if @reset_attempts.nil?
      session['reset_attempt'] ||= 0
      @reset_attempts = session['reset_attempt'] += 1
    end
    @reset_attempts
  end
end
