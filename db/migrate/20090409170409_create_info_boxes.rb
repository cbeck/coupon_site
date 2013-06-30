class CreateInfoBoxes < ActiveRecord::Migration
  def self.up
    create_table :info_boxes do |t|
      t.integer :coupon_template_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :info_boxes
  end
end
