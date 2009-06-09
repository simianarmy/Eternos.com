require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class RoutingTest < Test::Unit::TestCase
  def test_should_include_plugin_controller_paths
    expected = %W(
      #{Rails.root}/app/controllers
      #{HELPER_RAILS_ROOT}/app/controllers
      #{Rails.root}/vendor/plugins/users/app/controllers
      #{Rails.root}/vendor/plugins/plugin_with_custom_paths/app/controllers
      #{Rails.root}/vendor/plugins/plugin_with_namespaced_paths/app/controllers
      #{Rails.root}/vendor/plugins/plugin_with_routes/app/controllers
      #{Rails.root}/vendor/plugins/plugin_with_standard_paths/app/controllers
    )
    
    assert_equal expected, ActionController::Routing.controller_paths
  end
end
