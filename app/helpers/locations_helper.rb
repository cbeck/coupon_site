module LocationsHelper
  def states
    @@states ||= State.find :all
  end

  def google_map_key
    Location.google_map_key
  end

  def google_maps?(loc=nil)
    Location.maps_enabled && !Location.google_map_key.nil? && !loc.nil? #&& !loc.lat.nil?
  end
end
