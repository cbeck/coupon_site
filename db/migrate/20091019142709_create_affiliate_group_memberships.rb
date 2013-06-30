class CreateAffiliateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :affiliate_group_memberships do |t|
      t.integer :affiliate_id
      t.integer :affilitate_group_id
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliate_group_memberships
  end
end
