module AdsHelper
  def render_ads(location)
    output = ""
    block = AdBlock.find_by_location(location)
    ads = block.available_ads
    unless ads.blank?
      classname = block.orientation
      output += "<ul class='ads #{classname}' id='ads'>"
        ads.each do |ad|
          output += "<li class='ad' id='#{dom_id(ad)}'>"
          output += link_to(image_tag(formatted_ad_path(ad, :jpg)), ad.click_url, :target => "_new")
          output += "</li>"
        end
      output += "</ul>"
    end
    output
  end
  
  def render_ad_status(ad)
    output = ""
    if ad.enabled? 
      output += image_tag('tick.png')
    else
      output += image_tag('cancel.png')
    end
    output
  end
end
