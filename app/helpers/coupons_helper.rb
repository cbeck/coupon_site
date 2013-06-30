module CouponsHelper
  
  def include_coupon_map?
    @include_map
  end
  
  def render_coupon_info(coupon)
    output = ""
    output += "<p>#{coupon.location.to_html}</p>" if coupon.coupon_template.show_location?
    output += "<p>#{coupon.phone}</p>" if coupon.coupon_template.show_phone?
    output += "<p>#{coupon.email}</p>" if coupon.coupon_template.show_email?
    output += "<p><a href=\"#{coupon.website.to_s}\" target='_new'>#{coupon.website.to_s}</a></p>" if coupon.coupon_template.show_website? && !coupon.website.blank?
    unless coupon.info_boxes.blank?
      coupon.info_boxes.each {|ib|
        output += "<p>#{ib.name}: #{text_field_tag 'tag'}</p>"
      }
    end
    output
  end
  
  def render_coupon_link(coupon, clipped_coupon=nil)
    output = ""
    output += link_to_function(image_tag('icons/view.png'), render_coupon_path(coupon, clipped_coupon))
    output += link_to_function "View", render_coupon_path(coupon, clipped_coupon)
  end
  
  def render_coupon_path(coupon, clipped_coupon=nil)
    path = (clipped_coupon) ? coupon_url(coupon, :clipped_coupon => clipped_coupon) : coupon_url(coupon)
    output = "Modalbox.show('#{path}', {title: \"#{coupon.name} from #{coupon.business.name}\", width: 700})"
  end
  
end
