class Account < ActiveRecord::Base
  belongs_to :affiliate
  has_many :businesses, :dependent => :destroy
  has_many :coupon_templates, :dependent => :destroy
  has_many :images, :as => :viewable, :order => 'position'
  acts_as_taggable_on :tags
  acts_as_paranoid
  
  validates_presence_of :affiliate_id 
  
  def primary_business?
    !businesses.nil? && !businesses.primary.empty?
  end
  
  def primary_business
    businesses.primary.first unless businesses.blank?
  end
  
  def short_name
    (name.length > 35) ? "%-05.32s..." % name : name   
  end
  
  def expiring_coupons
    expiring = coupon_templates.select {|c| c.expiring?}
    expiring.sort_by{|expiring| expiring.expired_on } unless expiring.empty?
  end
  
  def has_no_active_coupons?
    coupon_templates.active.blank?
  end
  
  def self.no_active_coupons_since(date)
    accounts = Account.find(:all, :include => :coupon_templates)
    accounts.select {|acct| acct.coupon_templates.blank? || acct.coupon_templates.had_active_since(date).blank?}
  end
  
  def has_expiring_coupons?
    !expiring_coupons.blank?
  end
  
  def coupons_for_event_type(event_type)
    viewed = []
    coupon_templates.each {|coupon_template|
      viewed << coupon_template.coupons_for_event_type(event_type)
    }
    viewed.flatten
  end
  
  def coupons_viewed
    coupons_for_event_type(:view)
  end
  
  def view_all_coupons
    primary_business.available_coupons.each {|coupon|
      coupon.view
    } unless primary_business.blank? || coupon_templates.blank?
  end
  
  def coupons_printed
    coupons_for_event_type(:print)
  end
  
  def coupons_clipped
    coupons_for_event_type(:clip)
  end
  
  def offer_names
    coupon_templates.collect {|ct| ct.name }.uniq
  end
  
  def logo
    images.first
  end
  
  def logo?
    !images.blank?
  end
  
  def photos
    images[1..images.size] 
  end
  
  def photos?
    images.size > 1
  end
  
  def description
    (primary_business?) ? primary_business.description : ""
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def data=(pdata)    
    set_model_attributes(:images, pdata[:image])
    
    pdata[:tag].each do |tag|
      tag_list << tag['name'] unless tag.has_key?('id')
    end unless pdata[:tag].blank?
    
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
