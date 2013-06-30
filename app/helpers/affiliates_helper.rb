module AffiliatesHelper
  
  def render_billable_status(affiliate)
    output = ""
    if affiliate.billable? 
      output += image_tag('tick.png')
    else
      output += image_tag('cancel.png')
    end
    output
  end
end
