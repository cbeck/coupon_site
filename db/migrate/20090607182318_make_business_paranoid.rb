class MakeBusinessParanoid < ActiveRecord::Migration
  def self.up
    add_column :businesses, :deleted_at, :datetime
  end

  def self.down
  end
end
