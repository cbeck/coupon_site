class AddPhoneToCouponTemplate < ActiveRecord::Migration
  def self.up
    add_column :coupon_templates, :show_phone, :boolean
  end

  def self.down
    remove_column :coupon_templates, :show_phone
  end
end
