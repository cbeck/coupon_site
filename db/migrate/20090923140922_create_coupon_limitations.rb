class CreateCouponLimitations < ActiveRecord::Migration
  def self.up
    create_table :coupon_limitations do |t|
      t.integer :coupon_template_id
      t.integer :limitation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_limitations
  end
end
