class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :viewable_id
      t.string :viewable_type
      t.string :image_filename
      t.integer :image_width
      t.integer :image_height
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
