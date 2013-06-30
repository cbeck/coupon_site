class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.integer :coupon_template_id
      t.integer :business_id
      t.integer :image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
