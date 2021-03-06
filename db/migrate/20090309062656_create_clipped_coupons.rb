class CreateClippedCoupons < ActiveRecord::Migration
  def self.up
    create_table :clipped_coupons do |t|
      t.string :coupon_id
      t.string :user_id
      t.boolean :favorite

      t.timestamps
    end
  end

  def self.down
    drop_table :clipped_coupons
  end
end
