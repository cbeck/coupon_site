class AddCustomLimitationToCouponTemplate < ActiveRecord::Migration
  def self.up
    change_table :coupon_templates do |t|
      t.boolean :has_custom_limitation
      t.string :custom_limitation
    end
  end

  def self.down
    change_table :coupon_templates do |t|
      t.remove :has_custom_limitation
      t.remove :custom_limitation
    end
  end
end
