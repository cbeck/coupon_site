class AddHomeTextToSiteConfig < ActiveRecord::Migration
  def self.up    
    SiteConfig.enumeration_model_updates_permitted = true
    
    SiteConfig.create :name => 'home_header', :value => 'Are you a coupon clipping pro? Newbie? Or just looking for a deal?',
        :description => 'The text that appears in bold to the left of the search box on the home page. HTML is allowed, but do NOT enclose in a header tag: <h4> is assumed.'

    SiteConfig.create :name => 'home_header_text', :value => 'Look no further. CarolinaCoupons.com has tons of coupons ready to search, clip and print online.',
        :description => 'The text that appears in under the header to the left of the search box on the home page. HTML is allowed, but do NOT enclose in <p> tags.'

  end

  def self.down
    header = SiteConfig[:home_header]
    text = SiteConfig[:home_header_text]
    SiteConfig.enumeration_model_updates_permitted = true
    header.destroy
    text.destroy    
  end
end
