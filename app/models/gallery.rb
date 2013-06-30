class Gallery < ActiveRecord::Base
  named_scope :available, :conditions => {:enabled => true}
  named_scope :photos, :conditions => ['has_logos is null or has_logos = ?', false]
  named_scope :logos, :conditions => ['has_logos = ?', true]
  
  has_many :images,   :as => :viewable, :dependent => :destroy, :order => 'position'
  
  def self.current_logo
    self.logos.first.images.first unless self.logos.blank? || self.logos.first.images.blank?    
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
