module MediaHelper
  
  def media_link(media, options={})
    format = options.delete(:format) || :jpg
    options[:alt] ||= "#{media.viewable.name} photo"
    image_tag(medium_path(media, :format => format), options)
  end
  
  def thumb_link(media, options={})
    format = options.delete(:format) || :jpg
    options[:alt] ||= "#{media.viewable.name} photo"
    image_tag(thumb_medium_path(media, :format => format), options)
  end

  def small_link(media, options={})
    format = options.delete(:format) || :jpg
    options[:alt] ||= "#{media.viewable.name} photo"
    image_tag(small_medium_path(media, :format => format), options)
  end

  def medium_link(media, options={})
    format = options.delete(:format) || :jpg
    options[:alt] ||= "#{media.viewable.name} photo"
    image_tag(medium_medium_path(media, :format => format), options)
  end
  
  def mini_link(media, options={})
    format = options.delete(:format) || :jpg
    options[:alt] ||= "#{media.viewable.name} photo"
    image_tag(mini_medium_path(media, :format => format), options)
  end
end