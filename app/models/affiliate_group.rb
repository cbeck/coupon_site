class AffiliateGroup < ActiveRecord::Base
  # This really is an individual site - it can be comprised of many affiliates
  
  has_many :affiliate_group_memberships, :dependent => :destroy
  has_many :affiliates, :through => :affiliate_group_memberships
  has_many :ad_placements
  has_many :affiliate_group_user_memberships
  has_many :users, :through => :affiliate_group_user_memberships
  
  # Doing it on this level because presumably each site could have its own contact messages
  has_many :contacts, :dependent => :destroy
  
  has_one :domain
  has_many :admins, :class_name => "User", :foreign_key => "user_id"
  
  def self.current
    tag = Thread.current[:affiliate_group] 
    tag || AffiliateGroup.first
  end
  
  def self.current=(affiliate_group)
    raise(ArgumentError, "Invalid affiliate group. Expected an object of class 'AffiliateGroup', got #{affilate_group.inspect}") unless affiliate_group.is_a?(AffiliateGroup)
    logger.info "Affiliate group for this thread being set to #{affiliate_group.inspect}"
    Thread.current[:affiliate_group] = affiliate_group
  end
  
  def accounts
    affiliates.collect(&:accounts).flatten
  end
  
  def account_ids
    accounts.collect(&:id)
  end
end
