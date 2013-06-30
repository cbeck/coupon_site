class EmailAddress < ActiveRecord::Base
  attr_accessor :required
  belongs_to :emailable, :polymorphic => true
  
  validates_presence_of :address, :message => '^Email address is required'

  validates_format_of :address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
      :message => '^Email address must be formatted correctly',
      :if => '!address.blank?'
      
  def to_s
   self.address
  end

end
