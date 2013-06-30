class AddAffiliateGroupIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :affiliate_group_id, :integer 
    
    create_table :affiliate_group_user_memberships do |t|
      t.integer :affiliate_group_id
      t.integer :user_id
      t.timestamps
    end
       
    add_index :users, :affiliate_group_id
    add_index :affiliate_group_user_memberships, :affiliate_group_id
    add_index :affiliate_group_user_memberships, :user_id
  end

  def self.down
    remove_column :users, :affiliate_group_id
  end
end
