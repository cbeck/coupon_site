class AddNewStatusToIssueStatuses < ActiveRecord::Migration
  def self.up
    IssueStatus.enumeration_model_updates_permitted = true
    IssueStatus.create :name => "New"
  end

  def self.down
    IssueStatus.enumeration_model_updates_permitted = true
    new_stat = IssueStatus.find_by_name("New")
    new_stat.destroy
  end
end
