class Person < ActiveRecord::Base
  attr_accessor :required
  has_many :email_addresses, :as => :emailable, :dependent => :destroy
  belongs_to :personable, :polymorphic => true
  has_one :location,  :as => :addressable,  :dependent => :destroy
  
  validates_presence_of :first_name, :message => '^First name is required'
  validates_presence_of :last_name, :message => '^Last name is required'
  
  def name=(str)
    arr = str.split(' ')
    self.last_name = arr.pop
    self.first_name = arr.join(' ')
  end
  
  def to_s
    "#{first_name} #{last_name}"
  end
end
