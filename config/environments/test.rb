# $Id$
# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!

# cache_classes must be true when running tests with cucumber
# must be false when running spec_server
config.cache_classes = (ENV['RUNNING_SPEC_SERVER'] != '1') || (ENV['RUNNING_CUCUMBER'] == '1')
puts "cache_classes = #{config.cache_classes}"

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

ASSET_HOST              = "dev.eternos.com"
REGISTER_USER_TO_FACEBOOK_ENABLED = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.cache_store = nil

config.gem 'rspec-rails', :version => '>= 1.3.2', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
