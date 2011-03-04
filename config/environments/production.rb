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

#Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

# Use SMTP protocol to deliver emails
config.action_mailer.delivery_method = :smtp

# Use memcache for session store in production environments!  db is too slow
config.action_controller.session_store = :mem_cache_store

# Setup memcached connection
config.after_initialize do
  # So that Passenger can find the identify command
  # Comment out for production b/c it keeps changing & it should find the system default /usr/bin!!
  #Paperclip.options[:command_path] = "/usr/local/bin"
  Paperclip.options[:swallow_stderr] = false
end

config.log_level = :debug