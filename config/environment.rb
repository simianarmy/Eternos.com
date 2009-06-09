# $Id$
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Authorization plugin for role based access control
# You can override default authorization system constants here.

# Can be 'object roles' or 'hardwired'
AUTHORIZATION_MIXIN = "object roles"

# NOTE : If you use modular controllers like '/admin/products' be sure
  # to redirect to something like '/sessions' controller (with a leading slash)
  # as shown in the example below or you will not get redirected properly
  #
  # This can be set to a hash or to an explicit path like '/login'
  #

LOGIN_REQUIRED_REDIRECTION = '/login'
PERMISSION_DENIED_REDIRECTION = '/member_home'

# The method your auth scheme uses to store the location to redirect back to
STORE_LOCATION_METHOD = :store_location

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
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  config.gem "ruby-openid", :lib => "openid", :version => ">= 2.1.2"
  config.gem 'image_science'
  config.gem 'rmagick', :lib => "RMagick", :version => ">= 2.9.2"
  config.gem 'ezcrypto'
  config.gem 'starling', :lib => "starling", :version => ">= 0.9.8"
  config.gem 'aws-s3', :lib => "aws/s3", :version => ">= 0.5.1"
  #config.gem 'rvideo', :version => ">= 0.9.3"
  config.gem 'active_presenter', :version => ">= 0.0.5"
  config.gem 'haml', :version => ">= 2.0.7"
  config.gem 'lockfile', :version => ">= 1.4.3"
  config.gem 'packr', :version => ">= 1.0.2"
  config.gem 'mime-types', :lib => "mime/types", :version => '>= 1.16'
  #config.gem 'authlogic'
  config.gem 'facebooker'
  config.gem 'amqp'
  config.gem 'chronic', :version => '>= 0.2.3'
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  #config.gem 'memcache-client', :version => ">= 1.7.1"
  #config.gem 'flvtool2', :version => ">= 1.0.6"
  
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
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = ENV['TZ'] = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_eternos.com_session',
    #:cookie_only => false,
    :secret      => '8ad163840e42b6893ad5c8ed99f6ee90db2fedb729963dd19447a53c3edeb00546ecd06e4a4cf1803542a2fe6f467f63c8a785825ed87adfe64d696586f1d0a1'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer, :guest_observer
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  config.load_paths << "#{RAILS_ROOT}/app/presenters"
  config.load_paths << "#{RAILS_ROOT}/app/renderers"
end

# Load email config
require 'load_email_configuration'
# Load tagging methods
require 'tag_extensions'
# For saas
require 'association_proxy'
require 'rvideo'
require 'mime/types'

# Various global constant strings
FLOWPLAYER_PRODUCT_KEY = '$3894b992d106ccc5f56'
YAHOO_APP_ID = 'YxNApcLV34EgbS7EoRCAgGY4hJvSX_fQeW9uayDJ0yUbtxH8dhZXKjOSI7k8Gic7'
FLASH_RECORDER_KEY = 'zyrc234mq7hbs6ptw5d1v9n0j8xfkg'
RECORDING_CONTENT_PARENT_COOKIE = 'RECORDING_PARENT_ID'

ExceptionNotifier.exception_recipients = %w( marc@eternos.com )

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  "<span class='field_error'>#{html_tag}</span>"
end

# Need this to prevent the following in Renderer classes:
# ActionView::TemplateError: Missing host to link to! Please provide :host parameter or set default_url_options[:host]
include ActionController::UrlWriter
default_url_options[:host] = 'localhost'

# Disable email validator domain lookups
EmailVeracity::Config[:lookup] = false

ENV['RECAPTCHA_PUBLIC_KEY'] = '6Le7nwYAAAAAAEbuaM378Df7UkAr1vuM_52el9Bg'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Le7nwYAAAAAAOdPcWOZSu8K4P1CRFC1Djyn1pMw'
