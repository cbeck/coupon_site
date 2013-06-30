class ConvertCouponTemplateLimitations < ActiveRecord::Migration
  def self.up
    coupon_templates = CouponTemplate.all
    coupon_templates.each do |coupon|
      begin
        current_limit = Limitation.find(coupon.limitation_id )
        unless current_limit.blank?
          coupon.coupon_limitations << CouponLimitation.new(:coupon_template_id => coupon.id, :limitation_id => current_limit.id)
          coupon.save
        end
      rescue
        #do nothing
        next
      end
    end
    
    remove_column :coupon_templates, :limitation_id
  end

  def self.down
    add_column :coupon_templates, :limitation_id, :integer
    
    coupon_templates = CouponTemplate.all
    coupon_templates.each do |coupon|
      current_limit = coupon.coupon_limitations.first unless coupon.coupon_limitations.blank?
      unless current_limit.blank?
        coupon.update_attribute(:limitation_id, current_limit.limitation_id)
      end
    end
  end
end
