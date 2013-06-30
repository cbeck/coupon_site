class AddUserFields < ActiveRecord::Migration
  def self.up
    add_column :users, :zip, :string, :limit => 5
    add_column :users, :email2, :string
    add_column :users, :email3, :string
  end

  def self.down
    remove_column :users, :zip
    remove_column :users, :email2
    remove_column :users, :email3
  end
end
