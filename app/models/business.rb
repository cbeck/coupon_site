require 'ruby_extensions'

class Business < ActiveRecord::Base
  named_scope :primary, :conditions => {:primary => true}
  # after_save :generate_permalink
  after_update :save_data

  # attr_writer :images, :oldimages, :data
  attr_accessor :directory_ct
  attr_protected :user_id, :permalink

  acts_as_paranoid
  acts_as_taggable_on :tags
  # acts_as_commentable
  
  # belongs_to :theme
  belongs_to :account
  has_one :location,  :as => :addressable
  has_many :phones,   :as => :callable
  has_many :people,   :as => :personable
  has_many :email_addresses, :as => :emailable
  has_many :websites, :as => :netable
  has_one :schedule
  has_many :images,   :as => :viewable, :order => 'position'
  has_many :coupons
  belongs_to :user
  # composed_of :schedule, :mapping => %w(schedule to_s)
  
  acts_as_mappable :through => :location
  
  validates_presence_of :name, :message => '^Business name is required'
    
  # validates_length_of :phones, :minimum => 1,
  #   :message => '^You must have at least one phone'
  # validates_length_of :email_addresses, :minimum => 1,
  #   :message => '^You must have at least one email address'
  # validates_length_of :websites, :maximum => 5,
  #   :too_long => '^You may not have more than 5 websites'
  # validates_length_of :images, :maximum => 5, :allow_nil => true, 
  #   :too_long => 'You may not have more than 5 photos'

  validates_associated :location, :message => 'must have a valid, full address'
  validates_associated :phones, :message => 'must have at least one valid phone number'
  validates_associated [:people, :websites, :email_addresses], :allow_nil => true
  validates_associated :schedule, :allow_nil => true

  # see: http://www.hashrocket.com/blog/comments/geospatial_searches_with_thinkingsphinx/
  define_index do
    indexes :name, :sortable => true
    indexes :description
    indexes taggings.tag(:name), :as => :business_tags
    indexes account.taggings.tag(:name), :as => :account_tags
    
    has location.latitude, :as => :latitude
    has location.longitude, :as => :longitude
    
    # set_property :delta => :datetime, :threshold => 1.hour
    set_property :enable_star => true
    set_property :min_prefix_len => 3
  end
  
  def self.per_page
    (SiteConfig[:businesses_per_page] || 15).to_i
  end  

  def use_local_logo?
    override_logo? || account.logo.blank?
  end
  
  def logo
    (use_local_logo?) ? images.first : account.images.first    
  end
  
  def logo?
    !logo.blank?
  end
  
  def local_photos
    (use_local_logo?) ? images[1..images.size] : images
  end
  
  def photos
    (account.photos?) ? local_photos + account.photos : local_photos
  end
  
  def photos?
    !photos.blank?
  end
  
  def emails
    (email_addresses.blank? && account.primary_business) ? account.primary_business.email_addresses : email_addresses
  end
  
  def urls
    (websites.blank? && account.primary_business) ? account.primary_business.websites : websites
  end
  
  def schedule?
    !schedule.nil? && !schedule.omit?
  end
  
  def available_coupons
    coupons.select {|coupon| coupon.coupon_template.available? unless coupon.nil? or coupon.coupon_template.blank? }
  end
  
  def has_available_coupons?
    !available_coupons.empty?
  end
  
  def view_all_coupons
    available_coupons.each {|coupon|
      coupon.view
    } unless coupons.blank?
  end
  
  def main_description
    description || account.description
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
  
  def data=(pdata)
    
    if location.nil? || location.new_record? 
      build_location(pdata[:location])
    else
      location.update_attributes pdata[:location]
    end
    
    if schedule.nil? || schedule.new_record? 
      build_schedule(pdata[:schedule])
    else
      schedule.update_attributes pdata[:schedule]
    end
    
    pdata[:tag].each do |tag|
      tag_list << tag['name'] unless tag.blank? || tag.has_key?('id')
    end unless pdata[:tag].blank?
    
    unless pdata[:person].nil?
      set_model_attributes(:people, pdata[:person].select{|p| !p["first_name"].blank? })
    end
    
    unless pdata[:phone].nil?
      set_model_attributes(:phones, pdata[:phone].select{|p| !p["formatted_number"].blank? })
    end
    
    unless pdata[:email_address].nil?
      set_model_attributes(:email_addresses, pdata[:email_address].select{|p| !p["address"].blank? })
    end
    
    unless pdata[:website].nil?
      set_model_attributes(:websites, pdata[:website].select{|p| !p["url"].blank? })
    end
    
    unless pdata[:image].nil?
      set_model_attributes(:images, pdata[:image].select{|p| !p["image_file"].blank? || !p["image_file_url"].blank? })
    end
  end
  
  private
  
  def save_data
    location.save(false) unless location.nil?
    schedule.save(false) unless schedule.nil?
    people.each {|p| p.save(false) }
    phones.each {|p| p.save(false) }
    email_addresses.each {|e| e.save(false) }
    websites.each {|w| w.save(false) }
    images.each {|i| i.save(false)}
  end
  
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
    
  # def generate_permalink
  #   if self.permalink.blank?
  #     code = self.name.tr("^[A-Za-z0-9]", "").underscore
  #     code = code.sub(/([a-z])([0-9])/) {|m| "#{$1}_#{$2}"}
  #     self.permalink = "#{self.id}-#{code}"
  #     save
  #   end
  # end
end
