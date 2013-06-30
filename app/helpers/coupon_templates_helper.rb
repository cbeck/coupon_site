module CouponTemplatesHelper
  
  def render_offer(offer, offer_values=nil)
    output = ""
    unless offer.blank? 
      unless offer_values.blank?
        values = offer_values.split(',')
        output += offer.name.gsub(/\[blank\]+/) {|o| values.shift}
      end
      output += offer.name if output.blank?
    end
    output
  end
  
  def render_offer_input(offer, offer_values)
    output = ""
    values = (offer_values.blank?) ? [] : offer_values.split(',')
    output += offer.name.gsub(/\[blank\]+/) {|o| text_field_tag('offer_values[]', values.shift)}
    output += offer.name if output.blank?
    output
  end
  
  def render_coupon_template_link(coupon_template)
    output = ""
    text = coupon_template.account.name + ": " + render_offer(coupon_template.offer, coupon_template.offer_values)
    text = (text.length > 33) ? "%-05.30s..." % text : text
    output += link_to(text, details_account_path(coupon_template.account))
  end
  
  def render_coupon_template_class(coupon_template)    
    output = case
    when coupon_template.expired?
      "no_active"
    when coupon_template.expiring?
      "expiring"
    end
    output
  end
  
 
end
