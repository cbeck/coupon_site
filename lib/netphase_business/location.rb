module Netphase

  class Location < ActiveRecord::Base
    # key for ubl.local
    @@google_map_key = "ABQIAAAA7Xr8w5bUDzY7jUp3mg8rYhSVqogFk-jvR0RyAo-ggdrT4SnahRRvbS-bSqX-K-jauaxRpOK6j0D6mw"

    @@geocoder = GoogleGeocode.new(@@google_map_key)

    @@maps_enabled = true

    # key for localhost
    # "ABQIAAAA7Xr8w5bUDzY7jUp3mg8rYhR37a7NquOOzWaWYKSDH6bV1uofQBQP_v0MmpAvVPT5UliP-Q3DBeg-jg"
 
    cattr_accessor :google_map_key
    cattr_accessor :geocoder
    cattr_accessor :maps_enabled

    before_save :geocode, :set_country
    belongs_to :addressable, :polymorphic => true

    @@state_codes = %w(AL AK AZ AR CA CO CT DC DE FL GA HI ID IL IN IA 
              KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM 
              NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA 
              WV WI WY)

    validates_presence_of [:address_line1, :city, :postal_code], :message => 'is required'  
    validates_presence_of :state, :if => :province_required?, :message => 'is required'
    # validates_format_of :postal_code, :with => /^\d{5}\-?\d*$/

    # validates_size_of :state, :is => 2
    # validates_inclusion_of :state, :in => @@state_codes,
    #   :message => 'Must be a valid 2-letter state code'

    def province_required?
      %w(US).include? self.country
    end

    def geocode(force=false)
      unless geocoder.nil?
        if force || self.longitude.nil? || self.latitude.nil?
          # gg = GoogleGeocode.new Location.google_map_key
          loc = geocoder.locate "#{self.address_line1}, #{self.city}, #{self.state}"
          self.longitude = loc.longitude
          self.latitude = loc.latitude
        end
      end
      rescue
        logger.error "geocode failed. $!"
    end  

    private
    def set_country
      if self.country.nil?
        self.country = 'US' if @@state_codes.include? self.state
      end
    end
  end
end