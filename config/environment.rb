# $Id$
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# REQUIRED BEFORE BOOT WHEN USING AWESOME bundle exec ... !
ENV['INLINEDIR'] ||= File.join(RAILS_ROOT, 'tmp', 'ruby_inline')

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

# Various global constant strings
MEMCACHED_OPTIONS       = {
  :c_threshold => 10_000,
  :compression => true,
  :debug => false,
  :namespace => 'ETERNOS',
  :readonly => false,
  :urlencode => false
}
MEMCACHED_HOST          = '127.0.0.1'

FLOWPLAYER_PRODUCT_KEY  = '#$c7beeb5fc7f67acac4d'
YAHOO_APP_ID            = 'YxNApcLV34EgbS7EoRCAgGY4hJvSX_fQeW9uayDJ0yUbtxH8dhZXKjOSI7k8Gic7'
FLASH_RECORDER_KEY      = 'zyrc234mq7hbs6ptw5d1v9n0j8xfkg'
MOD_PORTER_SECRET       = 'sh4mAlam4d1nGd0ng' 
RECORDING_CONTENT_PARENT_COOKIE = 'RECORDING_PARENT_ID' # TODO: check if used
SESSION_DURATION_SECONDS  = 86400 # 1 day before session times out
MAX_TAG_CLOUD_SIZE      = 50
ASSET_HOST              = "assets.eternos.com"
FACEBOOK_FAN_PAGE       = "http://www.facebook.com/pages/Eternoscom/134291337425"
REGISTER_USER_TO_FACEBOOK_ENABLED = true

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
  # WRONG: Use Bundler
    
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  config.i18n.default_locale = :en
  
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = ENV['TZ'] = 'UTC'

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
  
  config.cache_store = :mem_cache_store, MEMCACHED_HOST
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  config.load_paths << "#{RAILS_ROOT}/app/presenters"
  config.load_paths << "#{RAILS_ROOT}/app/renderers"
  config.load_paths << "#{RAILS_ROOT}/app/middleware"
  
  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = Proc.new { |source, request|
    unless source.starts_with?('//')
      (request ? request.protocol : 'http://') + ASSET_HOST
    end
  }
  
  config.after_initialize do
    unless RAILS_ENV == 'test'
      Qusion.start
      # Ensure EM reactor is running
      RAILS_DEFAULT_LOGGER.info "=> Launching Workling..."
      # Setup workling
      Workling::Remote.invoker = Workling::Remote::Invokers::EventmachineSubscriber
      Workling::Remote.dispatcher = Workling::Remote::Runners::ClientRunner.new
      Workling::Remote.dispatcher.client = Workling::Clients::AmqpClient.new
      RAILS_DEFAULT_LOGGER.info "=> done"
    end
    
    # Set ActionMailer host for url_for
    ActionMailer::Base.default_url_options[:host] = AppConfig.base_domain
    
    # Need this to prevent the following in Renderer classes:
    # ActionView::TemplateError: Missing host to link to! Please provide :host parameter or set default_url_options[:host]
    include ActionController::UrlWriter
    default_url_options[:host] = AppConfig.base_domain
  end
end

# Load email config
require 'load_email_configuration'
# custom libs
require 's3_helper'
require 'timeline_events'
require 'facebook_desktop'
require 'facebook_user_profile'
require 'message_queue'
require 'mail_history'
require 'content_collections'
# For saas
require 'association_proxy'
# 3rd party libs 
require 'rvideo'
require 'mime/types'
require 'shared-mime-info'
require 'whenever' # For Capistrano requirement
require 'rio' # Fast IO
require 'feedzirra'
require 'right_aws'
require 'thinking_sphinx'

ExceptionNotifier.exception_recipients = %w( marc@eternos.com )

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  "#{html_tag}<span class='field_error'></span>"
end

# Disable email validator domain lookups
EmailVeracity::Config[:lookup] = false

# Change this keys with your own domain
ENV['RECAPTCHA_PUBLIC_KEY'] = '6Le7nwYAAAAAAEbuaM378Df7UkAr1vuM_52el9Bg'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Le7nwYAAAAAAOdPcWOZSu8K4P1CRFC1Djyn1pMw'

Rubaidh::GoogleAnalytics.tracker_id = 'UA-9243545-1'
Rubaidh::GoogleAnalytics.local_javascript = true

# Spawn should fork by default in all environments
Spawn::method :fork
Spawn::method :yield, 'test' # Don't fork in tests
#Spawn::method :thread, 'production'

# Switch from REXML to Nokogiri for XML parsing since we use Nokogiri for 
# feed parsing already
ActiveSupport::XmlMini.backend = 'Nokogiri'

ActionMailer::Base.sendmail_settings = { 
  :location       => '/usr/sbin/sendmail', 
  :arguments      => '-i -t'
}


