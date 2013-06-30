class ContactMailer < ActionMailer::Base
  
  def contact_message(contact)    
    @recipients  = contact.contact_issue.email
    @from        = SUPPORT_EMAIL
    @subject     = "[CC] #{contact.contact_issue.name}"
    @sent_on     = Time.now
    @body[:contact] = contact
  end
  
end
