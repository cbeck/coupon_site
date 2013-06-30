class CouponLimitation < ActiveRecord::Base
  belongs_to :coupon_template
  belongs_to :limitation
end
