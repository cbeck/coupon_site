IssueStatus.enumeration_model_updates_permitted = true
unless Contact.count > 0
  IssueStatus.delete_all 

  IssueStatus.create :name => "Open"
  IssueStatus.create :name => "Resolved"
  IssueStatus.create :name => "Flagged"
  IssueStatus.create :name => "New"
  
else
  puts "Can't recreate issue statuses because there are #{Contact.count} existing contact messages"
end