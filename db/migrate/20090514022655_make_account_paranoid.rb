class MakeAccountParanoid < ActiveRecord::Migration
  def self.up
    add_column :accounts, :deleted_at, :datetime
  end

  def self.down
  end
end
