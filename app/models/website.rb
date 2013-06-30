class Website < ActiveRecord::Base
  before_save :clean_url
  
  belongs_to :netable, :polymorphic => true  
  
  validates_presence_of :url
  
  # validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
  #   :message => 'website address must be valid'

  def to_s
    self.url
  end

  def clean_url
    self.url = "http://#{self.url}" unless self.url =~ /http:/
  end
end
