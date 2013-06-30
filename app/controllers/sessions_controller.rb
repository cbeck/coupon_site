# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :add_layout

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag      
      flash[:notice] = "Thank you for logging in."
      unless params[:coupon_id].blank?
        clipped = ClippedCoupon.find_by_coupon_id_and_user_id(params[:coupon_id], user.id)
        clipped_coupon = clipped || ClippedCoupon.create(:coupon_id => params[:coupon_id], :user_id => user)
        clipped_coupon.coupon.clip
        flash[:notice] += (clipped) ? "You have already clipped that coupon, though." : " Your coupon has been added to your clipped coupons."        
      end
      redirect_back_or_default('/')
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      flash[:notice] = "Logged in failed"
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
