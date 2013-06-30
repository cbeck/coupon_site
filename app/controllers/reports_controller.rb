class ReportsController < ApplicationController
  before_filter :admin_required, :add_layout
  
  def index
  end
  
  def expired_coupons_report
    @expired = CouponTemplate.expired_and_not_renewed || []
    @expired_sort = params[:expired_sort] || "end_date"
    @expired = sort_templates(@expired, @expired_sort)
  end
  
  def basic_coupons_report
    @coupons = CouponTemplate.all
    @coupons_sort = params[:coupons_sort] || "viewed"
    @coupons = sort_templates(@coupons, @coupons_sort)
  end
  
  def high_redemptions_report
    @coupons = CouponTemplate.all
    @coupons = @coupons.select {|coupon| coupon.high_redemption_rate?}
    @coupons_sort = params[:coupons_sort] || "viewed"
    @coupons = sort_templates(@coupons, @coupons_sort)
  end
  
  def expiring_coupons_report
    expiring = 1.week.from_now
    begin 
      expiring = Date.parse params[:expired_on]
    rescue
      # bad date - do nothing
    end
    @expiring_date = expiring.strftime('%B %d, %Y')
    @expiring = CouponTemplate.expires(expiring) || []
    @expiring_sort = params[:expiring_sort] || "end_date"
    @expiring = sort_templates(@expiring, @expiring_sort)    
  end
  
  def no_active_coupons_report
    beginning = 1.week.ago
    begin 
      beginning = Date.parse params[:begin_on]
    rescue
      # bad date - do nothing
    end
    @beginning_date = beginning.strftime('%B %d, %Y')
    @accounts = Account.no_active_coupons_since(beginning) || []   
  end
  
  def no_redemptions_report
    beginning = 1.week.ago
    begin 
      beginning = Date.parse params[:begin_on]
    rescue
      # bad date - do nothing
    end
    @beginning_date = beginning.strftime('%B %d, %Y')
    @not_redeemed = CouponTemplate.no_redemptions_since(beginning) || []
    @not_redeemed_sort = params[:not_redeemed_sort] || "end_date"
    @not_redeemed = sort_templates(@not_redeemed, @not_redeemed_sort)
  end
  
end
