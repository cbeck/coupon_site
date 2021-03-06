class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.integer :contact_issue_id
      t.string :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
