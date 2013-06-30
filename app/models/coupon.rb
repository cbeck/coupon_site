class Coupon < ActiveRecord::Base  
  belongs_to :coupon_template
  belongs_to :business
  belongs_to :image
  
  has_many :clipped_coupons, :dependent => :destroy
  
  acts_as_eventable
    
  def name
    coupon_template.name
  end
  
  def account
    coupon_template.account
  end
  
  def offer
    coupon_template.offer.name
  end
  
  def expiring?
    coupon_template.expiring?
  end
  
  def available?
    coupon_template.available?
  end

  def self.per_page
    (SiteConfig[:coupons_per_page] || 30).to_i
  end  
  
  def logo
    business.logo unless business.blank? || business.logo.blank?
  end
  
  def clip_art
    coupon_template.image
  end
  
  def location
    if coupon_template.use_primary? || business.location.blank?
      business.account.primary_business.location
    else
      business.location
    end
  end
  
  def email
    get_business_association('email_addresses')
  end
  
  def website
    site = get_business_association('websites')
  end
  
  def phone
    get_business_association('phones')
  end
  
  def get_business_association(association)
    (coupon_template.use_primary? || business.send(association).blank?) ? business.account.primary_business.send(association).first : business.send(association).first
  end
  
  def limit
    coupon_template.limit
  end
  
  def info_boxes
    coupon_template.info_boxes
  end
  
end
