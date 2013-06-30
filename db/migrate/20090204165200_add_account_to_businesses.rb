class AddAccountToBusinesses < ActiveRecord::Migration
  def self.up    
    change_table :businesses do |t|
      t.integer :account_id
      t.boolean :primary     
      t.remove_index :user_id 
      t.remove :user_id  
      t.index :account_id    
    end
    
  end

  def self.down
    change_table :businesses do |t|
      t.remove_index :account_id
      t.remove :account_id
      t.remove :primary
      t.integer :user_id
      t.index :user_id
    end
    
  end
end
