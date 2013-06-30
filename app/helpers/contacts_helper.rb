module ContactsHelper
  def render_flag_link(contact)
    output = ""
    if contact.flagged? 
      output += link_to_remote(image_tag('flag_blue.png'), :url => flag_contact_path(contact))
    else
      output += link_to_remote(image_tag('blank.png'), :url => flag_contact_path(contact))
    end
    output
  end
  
  def render_status_link(contact)
    output = ""
    if contact.resolved? 
      output += link_to_remote(image_tag('tick.png'), :url => toggle_contact_path(contact))
    elsif contact.new?
      output += link_to_remote(image_tag('email.png'), :url => toggle_contact_path(contact))
    else
      output += link_to_remote(image_tag('email_open.png'), :url => toggle_contact_path(contact))
    end
    output
  end
end
