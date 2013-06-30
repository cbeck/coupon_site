class AddAffiliateGroupToContactMessages < ActiveRecord::Migration
  def self.up
    add_column :contacts, :affiliate_group_id, :integer
    
    add_index :contacts, :affiliate_group_id
  end

  def self.down
    remove_column :contacts, :affiliate_group_id
  end
end
