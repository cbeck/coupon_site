class CreateContactIssues < ActiveRecord::Migration
  def self.up
    create_table :contact_issues do |t|
      t.string :name
      t.string :email
      t.integer :position

      t.timestamps
    end
    
    ContactIssue.create :name => 'Add my business', :email => 'sales@carolinacoupons.com', :position => 1
    ContactIssue.create :name => 'Account or password issue', :email => 'support@carolinacoupons.com', :position => 2
    ContactIssue.create :name => 'Report a problem', :email => 'reportabug@carolinacoupons.com', :position => 3
    ContactIssue.create :name => 'General feedback', :email => 'feedback@carolinacoupons.com', :position => 4
    ContactIssue.create :name => 'Other', :email => 'support@carolinacoupons.com', :position => 5

  end

  def self.down
    drop_table :contact_issues
  end
end
