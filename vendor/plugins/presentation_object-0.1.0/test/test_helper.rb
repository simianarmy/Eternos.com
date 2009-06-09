ENV["RAILS_ENV"] = "test"
RAILS_ENV="test"

require File.dirname(__FILE__) + "/../../../../config/environment"
require 'test/unit'
require 'hardmock'
require 'shoulda'
require File.dirname(__FILE__) + "/../lib/presentation_object"

class Test::Unit::TestCase
  def stub(options)
    @hardmock_mock_count ||= 0
    m = Hardmock::Mock.new @hardmock_mock_count+=1
    options.each_pair do |method, return_value|
      m.stubs!(method).returns(return_value)
    end
    m
  end
end