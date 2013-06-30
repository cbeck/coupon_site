class Image < ActiveRecord::Base
  acts_as_fleximage do
    image_directory           'public/uploaded_images'
    image_storage_format      :png
    require_image             true
    missing_image_message     'is required'
    invalid_image_message     'was not a readable image'
    output_image_jpg_quality  85

    preprocess_image do |image|
      image.resize '640x640'
    end    
  end
  
  acts_as_list :scope => :viewable
  belongs_to :viewable, :polymorphic => true

  def to_s
    (image_filename =~ /\/([^\/]*)$/) ? $1 : image_filename
  end
  
end

