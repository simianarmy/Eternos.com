# $Id$
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

ASSET_HOST              = "dev.eternos.com"

#Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

# Use SMTP protocol to deliver emails
config.action_mailer.delivery_method = :smtp

# Setup memcached connection
puts "=> Connecting to memcached on #{MEMCACHED_HOST}"
CACHE = MemCache.new MEMCACHED_OPTIONS
CACHE.servers = MEMCACHED_HOST

config.log_level = :debug

# So that Passenger can find the identify command
Paperclip.options[:command_path] = "/opt/local/bin"