class Search
  attr_accessor :query, :location, :geocode, :radius, :pagesize

  def initialize(params={})
    # ugh! gotta find a better way to simplify this
    unless params.blank?
      self.query = (params[:search] && params[:search][:query]) || params[:query] || params[:id]
      # self.query = self.query.singularize unless self.query.blank?
      self.location = (params[:search] && params[:search][:location]) || params[:location]
      self.radius = ((params[:search] && params[:search][:radius]) || params[:radius] || Search.default_radius).to_i
      self.pagesize = ((params[:search] && params[:search][:pagesize]) || params[:pagesize] || Search.default_pagesize).to_i
      # self.geocode = Location.geocoder.locate(self.location) rescue nil
    end
  end

  def self.default_radius
    @@default_radius ||= (SiteConfig[:search_radius] || 30).to_i
  end
    
  def self.radius_options
    @@radius_options ||= begin
      arr = [5, 10, 20, 30]
      arr << default_radius unless arr.member?(default_radius)
      arr.sort.collect(&:to_s)
    end
  end

  def self.default_pagesize
    @@default_pagesize ||= (SiteConfig[:businesses_per_page] || 30).to_i
  end
    
  def self.pagesize_options
    @@pagesize_options ||= begin
      arr = [10, 20, 50, 100]
      arr << default_pagesize unless arr.member?(default_pagesize)
      arr.sort.collect(&:to_s)
    end
  end

  def nearby(loc)
    begin
      latd = radius / 69.1
      lngd = radius / 53.0
      (loc.longitude <= geocode.longitude + lngd && loc.longitude >= geocode.longitude - lngd &&
       loc.latitude <= geocode.latitude + latd && loc.latitude >= geocode.latitude - latd)
    rescue
      ::ActiveRecord::Base.logger.error("nearby determination failed: #{$!}")
    end
  end
  
end