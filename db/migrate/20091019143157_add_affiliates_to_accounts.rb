class AddAffiliatesToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :affiliate_id, :integer
  end

  def self.down
    remove_column :accounts, :affiliate_id
  end
end
