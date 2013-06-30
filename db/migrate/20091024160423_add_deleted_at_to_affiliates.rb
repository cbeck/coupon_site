class AddDeletedAtToAffiliates < ActiveRecord::Migration
  def self.up
    add_column :affiliates, :deleted_at, :datetime
  end

  def self.down
    remove_column :affiliates, :deleted_at
  end
end
