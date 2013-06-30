module BusinessesHelper
  
  def hide_if_empty(item, attribute)
    value =item.send(attribute)
    display = (value.nil? || value.empty?) ? 'none' : 'block'
    "style='display: #{display}'"
  end
  
  def optional_attributes
    %w[description]
  end
  
  def optional_attribute_styles(item, optional_attributes)
    optional_attributes.collect do |p|
      display = (item.send(p).empty?) ? 'none' : 'block'
      "\##{p} { display: #{display}; }\n"
    end
  end

  def list_image(business, directory)
    'list-style-image: url(/images/bg_features.gif)' if business.directory?(directory)
  end

  def has_attachment?(attachment)
    !attachment.nil? && File.exists?(attachment.file_path)
  end

  def remove_category_link(cat, busn)
   link_to_remote(image_tag('bin.png', :title => 'remove category'), 
				:url => { :action => 'remove_category', :category_id => cat, :business_id => busn },
				:confirm => "Delete this category: #{cat.name}?",
				:success => "up(0).remove()")
  end

  def existing_field_id(form, object)
  	unless object.new_record?
  		form.hidden_field(:id, :index => nil)
  	end
  end

  def day_hour(time)
    hour, min = time.split ':'
    (hour.to_i <= 12) ? time : sprintf("%d:%s", hour.to_i - 12, min)
  end
  
end
