class CorrectSpellingInAffiliateGroupMemberships < ActiveRecord::Migration
  def self.up
    add_column :affiliate_group_memberships, :affiliate_group_id, :integer
    remove_column :affiliate_group_memberships, :affilitate_group_id
       
  end

  def self.down
    remove_column :affiliate_group_memberships, :affiliate_group_id
    add_column :affiliate_group_memberships, :affilitate_group_id, :integer
  end
end
