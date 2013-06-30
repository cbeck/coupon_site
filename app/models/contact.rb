class Contact < ActiveRecord::Base  
  named_scope :open, :conditions => {:issue_status_id => IssueStatus[:Open]}, :include => [:issue_status, :contact_issue]
  named_scope :resolved, :conditions => {:issue_status_id => IssueStatus[:Resolved]}, :include => [:issue_status, :contact_issue]
  named_scope :flagged, :conditions => {:issue_status_id => IssueStatus[:Flagged]}, :include => [:issue_status, :contact_issue]
  named_scope :all_open, lambda {
    {
      :conditions => ['issue_status_id in (?,?,?)', IssueStatus[:Open], IssueStatus[:Flagged], IssueStatus[:New]],
      :include => [:issue_status, :contact_issue]
    }
  }
  
  belongs_to :contact_issue
  belongs_to :issue_status
  belongs_to :affiliate_group  
  
  def open?
    issue_status == IssueStatus[:Open]
  end
  
  def flagged?
    issue_status == IssueStatus[:Flagged]
  end
  
  def resolved?
    issue_status == IssueStatus[:Resolved]
  end
  
  def new?
    issue_status == IssueStatus[:New]
  end
  
end
