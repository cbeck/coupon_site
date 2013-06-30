class AddSysadminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sysadmin, :boolean
  end

  def self.down
    remove_column :users, :sysadmin
  end
end
