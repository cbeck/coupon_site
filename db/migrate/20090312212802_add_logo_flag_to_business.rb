class AddLogoFlagToBusiness < ActiveRecord::Migration
  def self.up
    change_table :businesses do |t|
      t.boolean :override_logo
    end
  end

  def self.down
    change_table :businesses do |t|
      t.remove :override_logo
    end
  end
end
