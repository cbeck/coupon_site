SiteConfig.delete_all

SiteConfig.enumeration_model_updates_permitted = true

SiteConfig.create :name => 'search_radius', :value => 30,
  :description => 'Search radius in miles'

SiteConfig.create :name => 'initial_map_zoom', :value => 11,
  :description => 'Initial map zoom level.  May be closer if all results nearby.'

SiteConfig.create :name => 'coupons_per_page', :value => 30,
  :description => 'Coupons to display in search results (per page)'

SiteConfig.create :name => 'businesses_per_page', :value => 30,
  :description => 'Businesses (locations) to display in search results (per page)'

SiteConfig.create :name => 'maximum_coupon_days', :value => 90,
    :description => 'Maximum number of days a coupon may be active'

SiteConfig.create :name => 'popular_categories', :value => 'restaurant, auto, clothes',
    :description => 'Top level categories used for browsing (comma separated)'
    
SiteConfig.create :name => 'home_header', :value => 'Are you a coupon clipping pro? Newbie? Or just looking for a deal?',
    :description => 'The text that appears in bold to the left of the search box on the home page. HTML is allowed, but do NOT enclose in a header tag: <h4> is assumed.'

SiteConfig.create :name => 'home_header_text', :value => 'Look no further. CarolinaCoupons.com has tons of coupons ready to search, clip and print online.',
    :description => 'The text that appears in under the header to the left of the search box on the home page. HTML is allowed, but do NOT enclose in <p> tags.'

