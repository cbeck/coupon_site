class Domain < ActiveRecord::Base
  belongs_to :affiliate_group
  has_many :images, :as => :viewable, :order => 'position'
  
  def self.find_for_request_uri(request)
    scrubbed_url = Domain.scrub_url(request.host)
    url = scrubbed_url.match(/[\w\.]*/)[0]
    Domain.find_by_url(url) || Domain.first
  end
  
  def self.scrub_url(url)
    url.gsub(/(http:\/\/)?(www\.)?/, '')
  end
  
  def google_key
    google_map_key || Location.google_map_key
  end
  
  def display_name
    name || url.capitalize
  end 
  
  def logo
    logo? ? images.first : (Gallery.current_logo.blank?) ? nil : Gallery.current_logo 
  end
  
  def logo?
    !images.blank?
  end
  
  def data=(pdata)    
    set_model_attributes(:images, pdata[:image])
  end
  
  def set_model_attributes(name, model_attributes)
    return if model_attributes.blank?
    model_attributes.each do |attributes|
      if attributes[:id].blank?
        send(name).build(attributes)
      else
        model = send(name).detect {|t| t.id == attributes[:id].to_i}
        model.attributes = attributes unless model.nil?
      end
    end
  end
  
  private
  
  def update_images
    unless @images.nil?
      if !@images[:image_file].blank?
        self.images << Image.new(:image_file => @images[:image_file]) 
      elsif !@images[:image_file_url].blank?
        begin
          self.images << Image.new(:image_file_url => @images[:image_file_url])
        rescue
          logger.warn "Could not load image from #{@images[:image_file_url]}: $!"
          errors.add_to_base("Could not load image from #{@images[:image_file_url]}")
        end
      end 
    end
  end 
  
end
