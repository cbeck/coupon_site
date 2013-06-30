class CreateLimitations < ActiveRecord::Migration
  def self.up
    create_table :limitations do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :limitations
  end
end
