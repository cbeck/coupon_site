class Affiliate < ActiveRecord::Base
  has_many :affiliate_group_memberships, :dependent => :destroy
  has_many :affiliate_groups, :through => :affilate_group_memberships
  has_many :accounts, :dependent => :destroy
  
  has_one :location,  :as => :addressable
  has_many :phones,   :as => :callable
  has_many :people,   :as => :personable
  has_many :email_addresses, :as => :emailable
  has_many :websites, :as => :netable
  has_many :images,   :as => :viewable, :order => 'position'  
  
  acts_as_paranoid  
  
end
