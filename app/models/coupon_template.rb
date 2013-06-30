class CouponTemplate < ActiveRecord::Base
  named_scope :expires, lambda { |time_until| { :conditions => ['enabled = ? and expired_on <= ? and expired_on >= ? and account_id in(?)', true, time_until, Date.today, AffiliateGroup.current.account_ids] } }
  named_scope :available, lambda {
    {
      :conditions => ['enabled = ? and start_on <= ? and expired_on >= ? and account_id in(?)', true, Date.today, Date.today, AffiliateGroup.current.account_ids],
      :include => :account 
    }
  }
  named_scope :available_with_events, lambda {
    {
      :conditions => ['enabled = ? and start_on <= ? and expired_on >= ? and account_id in(?)', true, Date.today, Date.today, AffiliateGroup.current.account_ids],
      :include => {:coupons => [:events]}
    }
  }
  named_scope :active, lambda {
    {:conditions => ['enabled = ? and expired_on >= ? and account_id in(?)', true, Date.today, AffiliateGroup.current.account_ids]}
  }
  named_scope :expired, lambda {
    {:conditions => ['enabled = ? and expired_on < ? and account_id in(?)', true, Date.today, AffiliateGroup.current.account_ids]}
  } 
  named_scope :expired_since, lambda { |time_since| 
    {:conditions => ['enabled =? and expired_on <? and account_id in(?)', true, time_since, AffiliateGroup.current.account_ids]}
  }
  named_scope :had_active_since, lambda { |time_since| 
    {:conditions => ['enabled =? and start_on <= ? and expired_on >= ? and account_id in(?)', true, Date.today, time_since, AffiliateGroup.current.account_ids]}
  }
  named_scope :sorted_by_expiration, :conditions => ['order by expired_on ASC and account_id in(?)', AffiliateGroup.current.account_ids]
  
  belongs_to :account
  belongs_to :offer
  belongs_to :image
  belongs_to :original, :class_name => "CouponTemplate", :foreign_key => :original_id
  
  has_many :coupons, :dependent => :destroy
  has_many :businesses, :through => :coupons
  has_many :info_boxes, :dependent => :destroy
  has_many :renewals, :class_name => "CouponTemplate", :foreign_key => :original_id
  has_many :coupon_limitations
  has_many :limitations, :through => :coupon_limitations
  
  validate :not_active_more_than_max_days  
  
  def self.expiring 
    expiring = self.expires 1.week.from_now
    expiring.sort_by{|expiring| expiring.expired_on } unless expiring.empty?
  end
  
  def self.expired_and_not_renewed 
    expired = self.expired
    not_renewed = expired.select {|e| e.renewals.blank? } unless expired.blank?
    not_renewed.sort_by{|nr| nr.expired_on } unless not_renewed.blank?
  end
  
  def self.active_accounts
    self.available.blank? ? [] : self.available.collect {|avail| avail.account }.uniq 
  end
  
  def self.most_recent
    self.available.blank? ? [] : self.available.reverse[0,20]
  end
  
  def self.most_recent_accounts
    self.available.blank? ? [] : self.available.reverse.collect {|avail| avail.account }.uniq[0,20]
  end
  
  def expiring?
    expired_on <= 1.week.from_now.to_date && expired_on >= Date.today
  end
  
  def expired?
    expired_on < Date.today
  end
  
  def available?
    today = Date.today
    enabled? && (start_on <= today) && (expired_on >= today)
  end
  
  def limit
    limitation_text = (limitations.blank?) ? "No limitations or exclusions apply" : limitations.collect{|l| l.name}.to_sentence
    limit = (has_custom_limitation?) ? custom_limitation : limitation_text
  end
  
  def available_photos
    account.photos if account.photos?
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
    set_model_attributes(:info_boxes, pdata[:info_box])
    pdata[:coupon_limitation].each do |limit|
      if limit.has_key?('id')
        cl = coupon_limitations.find(limit[:id])
        cl.update_attribute(:limitation_id, limit[:limitation_id])
      else
        coupon_limitations << CouponLimitation.new(:coupon_template_id => id, :limitation_id => limit[:limitation_id])
      end
    end unless pdata[:coupon_limitation].blank?
  end
  
  def coupon_for_business(business)
    #coupons.find_by_business_id(business) - below has no db hit
    coupons.select {|c| c.business_id == business.id}.first
  end
  
  def has_display_data?
    show_location || show_website || show_phone || show_email
  end
  
  def coupons_for_event_type(event_type)
    viewed = []
    coupons.each {|coupon|
        viewed << coupon.events_by_event_type(event_type)
    }
    viewed.flatten
  end
  
  def viewed
    coupons_viewed.length
  end
  
  def coupons_viewed
    coupons_for_event_type(:view)
  end
  
  def printed
    coupons_printed.length
  end
  
  def coupons_printed
    coupons_for_event_type(:print)
  end
  
  def viewed?
    viewed > 0
  end
  
  def redeemed?
    printed > 0
  end
  
  def last_redeemed_on
    (redeemed?) ? coupons_printed.first.created_at : nil
  end
  
  def self.no_redemptions_since(date)
    coupons = CouponTemplate.available_with_events
    coupons.select {|coupon| !coupon.redeemed? || coupon.last_redeemed_on < date}
  end
  
  def high_redemption_rate?
    (redeemed? && viewed?) ? printed/viewed > 0.5 : false
  end
  
  def clipped
    coupons_clipped.length
  end
  
  def coupons_clipped
    coupons_for_event_type(:clip)
  end
  
  private
  
  def not_active_more_than_max_days
    errors.add_to_base("The maximum number of days a coupon may be active is #{SiteConfig[:maximum_coupon_days]}") unless (self.expired_on - self.start_on).to_i <= SiteConfig[:maximum_coupon_days].to_i    
  end
  
  
end
