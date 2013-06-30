class AddIssueStatusToContacts < ActiveRecord::Migration
  def self.up
    change_table :contacts do |t|
      t.integer :issue_status_id
    end
  end

  def self.down
    change_table :contacts do |t|
      t.remove :issue_status_id
    end
  end
end
