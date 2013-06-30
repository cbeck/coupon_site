class BootstrapIssueStatuses < ActiveRecord::Migration
  def self.up
    IssueStatus.enumeration_model_updates_permitted = true
    open = IssueStatus.create :name => "Open"
    IssueStatus.create :name => "Resolved"
    IssueStatus.create :name => "Flagged"
    
    contacts = Contact.all
    contacts.each do |contact|
      contact.update_attribute(:issue_status_id, open.id)
    end
  end

  def self.down
    IssueStatus.enumeration_model_updates_permitted = true
    IssueStatus.delete_all
  end
end
