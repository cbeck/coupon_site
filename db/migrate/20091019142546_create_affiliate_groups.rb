class CreateAffiliateGroups < ActiveRecord::Migration
  def self.up
    create_table :affiliate_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliate_groups
  end
end
