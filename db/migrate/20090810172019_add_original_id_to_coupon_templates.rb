class AddOriginalIdToCouponTemplates < ActiveRecord::Migration
  def self.up
    add_column :coupon_templates, :original_id, :integer
  end

  def self.down
    remove_column :coupon_templates, :original_id
  end
end
