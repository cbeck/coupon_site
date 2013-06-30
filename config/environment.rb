# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  config.gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com" 
  config.gem "acts-as-taggable-on", :version => '>= 2.0.6'
  config.gem 'geokit', :version => ">=1.2.0"
  config.gem "google-geocode", :lib => 'google_geocode'
  config.gem "thinking-sphinx", :version => '>= 1.3.15', :lib => "thinking_sphinx"
  config.gem 'will_paginate', :version => '>=2.3.12', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'calendar_date_select'
  config.gem 'metric_fu', :version => '>=1.3.0', :lib => 'metric_fu', :source => 'http://gems.github.com'
  config.gem 'whenever', :version => '>= 0.4.1'
  config.gem "newrelic_rpm"
  config.gem "liquid"
  config.gem "hoptoad_notifier", :version => '>=2.2.6'
  
  #config.gem "rspec-rails", :version => "1.1.11", :lib => 'spec/rails'
  # had to require spec because shoulda thinks that Spec is defined and then tries to call Spec::Runner
  # config.gem "thoughtbot-shoulda", :lib => 'shoulda', :source => 'http://gems.gitub.com'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_cms_session',
    :secret      => '5162aee5fe6d90f9c6c5916068ef0b7104ef2e7907eab44d23305372182075a3359770785480f76afdc4876388e8ce731377da24624f14a4dc9d06eb5a044188'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :user_observer, :contact_observer
  
end

require 'rails_extensions'

CATEGORIES = ['restaurant', 'auto']

SUPPORT_EMAIL = 'support@carolinacoupons.com'
SITE_KEY = "lkasgou913u4oier"
