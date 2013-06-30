require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  after_update :save_data
  
  belongs_to :affiliate_group

  has_one :location,  :as => :addressable,  :dependent => :destroy
  has_many :clipped_coupons
  has_many :coupons, :through => :clipped_coupons
  has_many :affiliate_group_user_memberships
  has_many :affiliate_groups, :through => :affiliate_group_user_memberships

  validates_format_of       :name, :with => Authentication.name_regex,  
    :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 4..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email, :with => Authentication.email_regex, 
    :message => Authentication.bad_email_message

  validates_presence_of     :zip
  validates_length_of       :zip, :is => 5
  # validates_format_of       :zip, :with => /\d{5}/

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :zip, :email2, :email3, :data, :admin, :sysadmin, :affiliate_group_id



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:email => email} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def forgot_password
    self.crypted_password = nil
    self.make_password_reset_code
    @forgotten_password = true
    save(false)
  end
  
  def reactivate
    self.crypted_password = nil
    self.make_password_reset_code
    self.activation_code = nil
    self.activated_at = Time.now
    @reactivate_user = true
    save(false)
    Notifications.deliver_react_user(self)
  end
 
  def recently_forgot_password?
    @forgotten_password
  end
 
  def reset_password    
    self.password_reset_code = nil
    self.password_reset_at = Time.now.utc
    @reset_password = true
    save(false)
  end
 
  def recently_reset_password?
    @reset_password
  end
  
  def passwd(p)
    self.password = p
    self.password_confirmation = p
    save(false) && "password reset"
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def data=(pdata)
    if location.nil? || location.new_record? 
      build_location(pdata[:location])
    else
      location.update_attributes pdata[:location]
    end
    location.update_attribute :postal_code, zip
  end
  
  def expiring_coupons
    expiring = clipped_coupons.select {|c| c.coupon && c.coupon.expiring? } unless clipped_coupons.blank?
    expiring.sort_by{|expiring| expiring.coupon.coupon_template.expired_on } unless expiring.blank?
  end
  
  def recently_clipped
    clipped_coupons.sort_by {|c| c.id} [0, 5] unless clipped_coupons.blank?
  end
  
  def available_coupons
    clipped_coupons.collect {|c| c.coupon if !c.coupon.blank? && c.coupon.available? }
  end
  
  def available_coupons_by_expiration
    available_coupons.sort_by {|c| c.coupon_template.expired_on } unless available_coupons.blank?
  end
  
  def available_clipped_coupons
    clipped_coupons.select {|c| !c.coupon.blank? && c.coupon.available? }
  end
  
  def available_clipped_coupons_by_expiration
    available_clipped_coupons.sort_by {|c| c.coupon.coupon_template.expired_on } unless available_clipped_coupons.blank?
  end
  
  def available_clipped_coupons_by_account
    available_clipped_coupons.sort_by {|c| c.coupon.coupon_template.account.name } unless available_clipped_coupons.blank?
  end
  
  def available_clipped_coupons_by_recent
    available_clipped_coupons.sort_by {|c| -c.id } unless available_clipped_coupons.blank?
  end
  
  protected
  
  def save_data
    location.save(false) unless location.nil?
  end

  def make_activation_code
      self.deleted_at = nil
      self.activation_code = self.class.make_token
  end

  def make_password_reset_code
    self.password_reset_code = 
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
