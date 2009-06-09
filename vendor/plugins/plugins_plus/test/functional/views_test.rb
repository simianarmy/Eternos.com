require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class ViewsTest < Test::Unit::TestCase
  def setup
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @controller = SiteController.new
  end
  
  def test_should_render_app_layout_with_app_view
    assert_equal "/app/views/layouts/app_layout: /app/views/site/app_layout_app_view\n\n", get(:app_layout_app_view).body
  end
  
  def test_should_render_app_layout_with_plugin_view
    assert_equal "/app/views/layouts/app_layout: /vendor/plugins/users/app/views/site/app_layout_plugin_view\n\n", get(:app_layout_plugin_view).body
  end
  
  def test_should_render_app_layout_with_app_and_plugin_view
    assert_equal "/app/views/layouts/app_layout: /app/views/site/app_layout_app_and_plugin_view\n\n", get(:app_layout_app_and_plugin_view).body
  end
  
  def test_should_render_plugin_layout_with_app_view
    assert_equal "/vendor/plugins/users/app/views/layouts/plugin_layout: /app/views/site/plugin_layout_app_view\n\n", get(:plugin_layout_app_view).body
  end
  
  def test_should_render_plugin_layout_with_plugin_view
    assert_equal "/vendor/plugins/users/app/views/layouts/plugin_layout: /vendor/plugins/users/app/views/site/plugin_layout_plugin_view\n\n", get(:plugin_layout_plugin_view).body
  end
  
  def test_should_render_plugin_layout_with_other_plugin_view
    assert_equal "/vendor/plugins/users/app/views/layouts/plugin_layout: /vendor/plugins/authenticated_users/app/views/site/plugin_layout_other_plugin_view\n\n", get(:plugin_layout_other_plugin_view).body
  end
  
  def test_should_render_plugin_layout_with_app_and_plugin_view
    assert_equal "/vendor/plugins/users/app/views/layouts/plugin_layout: /app/views/site/plugin_layout_app_and_plugin_view\n\n", get(:plugin_layout_app_and_plugin_view).body
  end
end
