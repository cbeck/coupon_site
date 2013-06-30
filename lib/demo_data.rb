class DemoData
  @@locations = Hash.new
  
  def phone
    format '%d%09d', rand(8)+2, rand(1000000000)
  end
    
  def expiration
    rand(365).days.from_now
  end
    
  def first_name
    names = %w(Jim John Mike Joe Jill James Joan Cindy Blair Paige Chase Tyler Vaughn Chris Sam Jeff Eric Mary Marylin Beth Amy Michele Pam Josh Alan George Bruce Ashley Walter Wilbur Barry Darby Kent Kelsey Kyle Lucy Merton Jeannine Megan Greg Jay Darrel Tim Foster Mark)
    names[rand(names.size)]
  end
    
  def last_name
    names = %w(Jones Johnson Ackers Benjamin Aldridge Arthur Ashford Clapp Conway Denton Fry Falkland Goodrich Hansel Heaton Henry Hogan Hurst Landon Kerr Morgan Ogden Osborn Paddock Randal Reynolds Rowley Roberts Sellick Stapleton Weller Artois Arundel Astor Barrow Barstow Beckett Bedford Bradford Breck Brighton Buckbee Cadwell Burton Dalton Davenport Dunbar Hartwell Hathaway Horton Irving Kinghorn Kirkpatrick Lancaster Lacy Lewes Milton Paxton Pollock Poole Sanders Scroggs Spalding Swift Thurston)
    names[rand(names.size)]
  end
  
  def person
    Person.new :first_name => first_name, :last_name => last_name
  end
  
  def user
    p = person
    login = "#{p.first_name[0..2]}#{p.last_name[0..7]}"
    u = User.create(:email => "#{login}_test@netphase.com",
      :salt => '6676525af203e88945fe64ecec835be0877fad65',
      :crypted_password => '8056aa624b3503242f478a0dacbbd1d40d7ce835', # test
      :person => p)
    u.register
    u.activate
  end
  
  def rand_lat(miles)
    dist = rand((miles/69.1)*10000000) / 10000000.0
    (rand(2)==0) ? dist : -dist
  end
  
  def rand_lng(miles)
    dist = rand((miles/53.0)*10000000) / 10000000.0
    (rand(2)==0) ? dist : -dist
  end
  
  def location(zip, miles)
    @@locations[zip] ||= Geokit::Geocoders::GoogleGeocoder.geocode(zip)  # Location.geocoder.locate(zip)
    loc = Location.create(:address_line1 => "#{rand(9999)} Random Rd",
      :city => @@locations[zip].city, 
      :state => 'NC', :postal_code => zip)
    loc.longitude = @@locations[zip].lng + rand_lng(miles)
    loc.latitude = @@locations[zip].lat + rand_lat(miles)
    loc
  end
    
  def business(name, zip, url=nil)
    u = User.find_by_email 'demo_user@netphase.com'
    b = Business.new(:name => name)
    b.save(false)
    b.user = u
    b.websites << Website.new(:url => url) unless url.nil?
    b.phones << Phone.new(:number => phone, :phone_type => 'work', :main => true)
    # b.description = LoremIpsum.words 30
    b.location = location(zip, 10)
    b if b.save(false)
  end

end