unless Contact.count > 0
  ContactIssue.delete_all 

  ContactIssue.create :name => 'Add my business', :email => 'sales@carolinacoupons.com', :position => 1
  ContactIssue.create :name => 'Account or password issue', :email => 'support@carolinacoupons.com', :position => 2
  ContactIssue.create :name => 'Report a problem', :email => 'reportabug@carolinacoupons.com', :position => 3
  ContactIssue.create :name => 'General feedback', :email => 'feedback@carolinacoupons.com', :position => 4
  ContactIssue.create :name => 'Other', :email => 'support@carolinacoupons.com', :position => 5
else
  puts "Can't recreate contact issues because there are #{Contact.count} existing contact messages"
end