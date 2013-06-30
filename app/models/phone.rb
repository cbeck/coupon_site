class Phone < ActiveRecord::Base
  attr_accessor :formatted_number
  before_validation :strip_formatting
  belongs_to :callable, :polymorphic => true
  
  @@types = %w(work mobile fax pager)
  
  validates_inclusion_of :phone_type, :in => @@types,
      :message => "^Phone type must be one of #{@@types.to_sentence}"
  validates_presence_of :number, :message => '^Phone number is required'
  validates_length_of :number, :minimum => 10, 
    :message => '^Use a full phone number, including area code',
    :if => '!number.blank?'

  def Phone.types
    @@types
  end
  
  def formatted_number
    if !self.number.blank? && self.number.size == 10
      "(#{self.number[0..2]}) #{self.number[3..5]}-#{self.number[6..9]}"
    else
      self.number
    end
  end
  def formatted_number=(n)
    self.number = n.tr "^0-9", ""
  end
  
  def to_s
    ext = " ext #{self.extension}" unless self.extension.nil?
    "(#{self.number[0..2]}) #{self.number[3..5]}-#{self.number[6..9]}#{ext}"
  end

  private
  def strip_formatting
    self.number.tr! "^0-9\+", ""
    
    # remove starting 0 or 1
    # self.number.sub! /^[01]/, ""
  end
end
