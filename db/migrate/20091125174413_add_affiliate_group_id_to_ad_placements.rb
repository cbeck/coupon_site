class AddAffiliateGroupIdToAdPlacements < ActiveRecord::Migration
  def self.up
    add_column :ad_placements, :affiliate_group_id, :integer
  end

  def self.down
    remove_column :ad_placements, :affiliate_group_id
  end
end
