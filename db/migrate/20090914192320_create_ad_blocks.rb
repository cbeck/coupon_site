class CreateAdBlocks < ActiveRecord::Migration
  def self.up
    create_table :ad_blocks do |t|
      t.string :location
      t.integer :available_placements
      t.string :orientation
      t.integer :columns
      t.text :stylesheet

      t.timestamps
    end
  end

  def self.down
    drop_table :ad_blocks
  end
end
