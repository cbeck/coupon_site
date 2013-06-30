class AddFlagToCouponTemplate < ActiveRecord::Migration
  def self.up
    change_table :coupon_templates do |t|
      t.boolean :enabled
    end
  end

  def self.down
    change_table :coupon_templates do |t|
      t.removed :enabled
    end
  end
end
