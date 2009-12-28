$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'date'
require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'rubygems'
require 'active_record/fixtures'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])

load(File.dirname(__FILE__) + "/schema.rb")

#ActiveSupport::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
#$LOAD_PATH.unshift(ActiveSupport::TestCase.fixture_path)

