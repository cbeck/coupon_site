class CreateCouponTemplates < ActiveRecord::Migration
  def self.up
    create_table :coupon_templates do |t|
      t.string :name
      t.integer :offer_id
      t.date :start_on
      t.date :expired_on
      t.integer :limitation_id
      t.boolean :show_location
      t.boolean :show_email
      t.boolean :show_website
      t.boolean :use_primary
      t.integer :image_id
      t.integer :account_id
      t.string :offer_values

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_templates
  end
end
