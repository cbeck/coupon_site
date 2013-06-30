class CreateAdPlacements < ActiveRecord::Migration
  def self.up
    create_table :ad_placements do |t|
      t.integer :ad_block_id
      t.integer :ad_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :ad_placements
  end
end
