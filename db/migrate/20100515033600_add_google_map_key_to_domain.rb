class AddGoogleMapKeyToDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :google_map_key, :string
  end

  def self.down
    remove_column :domains, :google_map_key
  end
end
