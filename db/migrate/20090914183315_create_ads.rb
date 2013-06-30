class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :name
      t.string :click_url
      t.boolean :enabled

      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
