class Ad < ActiveRecord::Base
  has_many :ad_placements, :dependent => :destroy
  has_many :ad_blocks, :through => :ad_placements
  
  acts_as_fleximage :image_directory => 'public/uploaded_images/ads'
end
