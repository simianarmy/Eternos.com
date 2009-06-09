require File.expand_path("#{File.dirname(__FILE__)}/../../test_helper")

module AppIntegration
class RoutingTest < Test::Unit::TestCase
  def setup
    @plugin = :plugin_with_routes
  end
  
  def test_should_load_routes_from_plugin_if_plugin_exists
    ActionController::Routing::Routes.draw do |map|
      map.from_plugin(@plugin)
    end
    
    assert_equal 1, ActionController::Routing::Routes.routes.size
    assert ActionController::Routing::Routes.routes[0].matches_controller_and_action?('plugin_with_routes_controller', 'index')
  end
  
  def teardown
    ActionController::Routing::Routes.reload!
  end
end

class RoutingWithMissingPluginTest < Test::Unit::TestCase
  def setup
    @plugin = :invalid
  end
  
  def test_should_raise_exception
    ActionController::Routing::Routes.draw do |map|
      assert_raise(MissingSourceFile) {map.from_plugin(@plugin)}
    end
    
    assert_equal [], ActionController::Routing::Routes.routes
  end
  
  def teardown
    ActionController::Routing::Routes.reload!
  end
end

class RoutingWithMissingRoutesTest < Test::Unit::TestCase
  def setup
    @plugin = :basic_plugin
  end
  
  def test_should_raise_exception
    ActionController::Routing::Routes.draw do |map|
      assert_raise(MissingSourceFile) {map.from_plugin(@plugin)}
    end
    
    assert_equal [], ActionController::Routing::Routes.routes
  end
  
  def teardown
    ActionController::Routing::Routes.reload!
  end
end
end
