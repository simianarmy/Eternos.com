# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
ENV['RUNNING_CUCUMBER'] = '1'
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'email_spec/cucumber'
require 'spec/expectations'
require 'fixjour'
require 'webrat'
require "webrat/rails" 
require 'webrat/core/matchers'

require File.expand_path(File.dirname(__FILE__) + "/../../spec/fixjour_builders.rb")
require File.expand_path(File.dirname(__FILE__) + "/../../spec/content_spec_helper.rb")

#require "webrat/rspec-rails"

Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

Webrat.configure do |config|
  config.mode = :rails
end

World(Fixjour)
World(ContentSpecHelper)

Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__)) + '/../../spec/fixtures/'
