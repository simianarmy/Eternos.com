# $Id$
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.debug_rjs                         = false

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = Proc.new { |source, request|
  "#{request.protocol}staging.eternos.com"
}
config.log_level = :debug

#Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

# Use SMTP protocol to deliver emails
config.action_mailer.delivery_method = :smtp

#config.log_level = :debug

# Setup memcached connection
puts "=> Connecting to memcached on #{MEMCACHED_HOST}"
CACHE = MemCache.new MEMCACHED_OPTIONS
CACHE.servers = MEMCACHED_HOST


