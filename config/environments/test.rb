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

config.action_controller.asset_host = Proc.new { |source, request|
  "#{request.protocol}dev.eternos.com"
}


# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'ruby-debug'
config.gem "rspec", :lib => false, :version => ">=1.2.2"
config.gem "rspec-rails", :lib => false, :version => ">=1.2.2"
config.gem "webrat", :lib => false, :version => ">=0.4.4"
config.gem "cucumber", :lib => false, :version => ">=0.3.0"
