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

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = Proc.new { |source, request|
  (request ? request.protocol : 'http://') + "staging.eternos.com"
}
#config.log_level = :debug

#Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

# Use SMTP protocol to deliver emails
config.action_mailer.delivery_method = :smtp

# Setup memcached connection
config.after_initialize do
  puts "=> Connecting to memcached on #{MEMCACHED_HOST}"
  CACHE = MemCache.new MEMCACHED_OPTIONS
  CACHE.servers = MEMCACHED_HOST
  
  # So that Passenger can find the identify command
  Paperclip.options[:command_path] = "/usr/local/bin"
end


