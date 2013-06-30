# require 'google_geocode'

class Location < ActiveRecord::Base
  acts_as_mappable :lat_column_name=>'latitude', :lng_column_name=>'longitude', 
    :auto_geocode=>true
  
  # key for moneysaver.local
  @@google_map_key =
    "ABQIAAAA7Xr8w5bUDzY7jUp3mg8rYhT4VDg_6_s1BOUAPwVoq8P68E8R0BRY6rZhGrLUH_WGM4-cJVvkOawTMQ"
  # 
  # @@geocoder = GoogleGeocode.new(@@google_map_key)
  
  @@maps_enabled = true
  
  cattr_accessor :google_map_key
  # cattr_accessor :geocoder
  cattr_accessor :maps_enabled
  
  # before_save :geocode, :set_country
  belongs_to :addressable, :polymorphic => true
  
  @@state_codes = %w(AL AK AZ AR CA CO CT DC DE FL GA HI ID IL IN IA 
            KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM 
            NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA 
            WV WI WY)
  
  @@coords = {}
  
  validates_presence_of [:address_line1, :city, :postal_code], :message => 'is required'  
  validates_presence_of :state, :if => :province_required?, :message => 'is required'
  # validates_format_of :postal_code, :with => /^\d{5}\-?\d*$/
  
  # validates_size_of :state, :is => 2
  # validates_inclusion_of :state, :in => @@state_codes,
  #   :message => 'Must be a valid 2-letter state code'

  def to_html(show_full=false)
      if show_full || !hidden?
        "#{address_line1}<br/>#{city}, #{state}  #{postal_code}"
      else
        postal_code
      end
  end
  
  def province_required?
    %w(US).include? self.country
  end
  
  def address(show_full=false)
    if show_full || !hidden?
    "#{self.address_line1}, #{self.city}, #{self.state} #{postal_code}"
    else
      postal_code
    end
  end
  
  # def geocode(force=false)
  #   unless geocoder.nil?
  #     if force || self.longitude.nil? || self.latitude.nil?
  #       # gg = GoogleGeocode.new Location.google_map_key
  #       loc = geocoder.locate "#{self.address_line1}, #{self.city}, #{self.state}"
  #       self.longitude = loc.longitude
  #       self.latitude = loc.latitude
  #     end
  #   end
  #   rescue
  #     logger.error "geocode failed. $!"
  # end
  
  # def distance_to(loc)
  #   earthRadius = 3956.0
  #   
  #   return radius * 2 * Math.Asin( Math.Min(1, Math.Sqrt( ( Math.Pow(Math.Sin((DiffRadian(lat1, lat2)) / 2.0), 2.0) + Math.Cos(ToRadian(lat1)) * Math.Cos(ToRadian(lat2)) * Math.Pow(Math.Sin((DiffRadian(lng1, lng2)) / 2.0), 2.0) ) ) ) );
  #   
  # end

  def within_radius(loc, miles)
    latd = miles / 69.1
    lngd = miles / 53.0
    (loc.longitude <= longitude + lngd && loc.longitude >= longitude - lngd &&
     loc.latitude <= latitude + latd && loc.latitude >= latitude - latd)
  end
  
  def city_geocode
    where = "#{city}, #{state}"
    @@coords[where] ||= begin
      loc = Location.geocode(where)
      {:lat => loc.lat, :lng => loc.lng, :full_address => loc.full_address.gsub(', USA', '')}
    end
  end

  private
  def set_country
    if self.country.nil?
      self.country = 'US' if @@state_codes.include? self.state
    end
  end
end
