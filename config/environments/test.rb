# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# config.gem "rspec", :lib => false, :version => ">= 1.3.0" 
# config.gem "rspec-rails", :lib => false, :version => ">= 1.3.2" 
# config.gem "cucumber", :lib => false, :version => ">= 0.3.5"
# config.gem "thoughtbot-factory_girl", :lib    => "factory_girl", :source => "http://gems.github.com"
config.gem "shoulda", :version => ">= 2.10.3"
config.gem "factory_girl", :version => ">= 1.2.3"
config.gem "webrat", :lib => false, :version => ">= 0.7.0"
config.gem "nokogiri", :lib => false, :version => ">= 1.2.3"

config.after_initialize do
  class StubGeocoder
    def locate
      { :latitude => 35.0352, :longitude => -80.8171 }
    end
  end
  
  # We don't want to ping the Google Geocode service everytime we create a new location
  # Location.geocoder = StubGeocoder.new

  require 'active_record/fixtures'
  Fixtures.create_fixtures("test/fixtures", %w(site_configs event_types issue_statuses affiliate_groups domains))

end

MY_HOST = 'rails.local'

