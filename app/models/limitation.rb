class Limitation < ActiveRecord::Base
  has_many :coupon_limitations
  has_many :coupon_templates, :through => :coupon_limitations
end
