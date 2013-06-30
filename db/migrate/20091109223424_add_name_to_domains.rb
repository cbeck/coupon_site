class AddNameToDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :name, :string
  end

  def self.down
    remove_column :domains, :name
  end
end
