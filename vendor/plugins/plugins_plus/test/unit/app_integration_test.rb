require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

module AppIntegration
class PluginByDefaultTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new('/path/to/plugin')
  end
  
  def test_should_have_an_app_path
    assert_equal '/path/to/plugin/app', @plugin.app_path
  end
  
  def test_should_not_have_any_app_load_paths
    assert @plugin.app_load_paths.empty?
  end
  
  def test_should_have_a_controllers_path
    assert_equal '/path/to/plugin/app/controllers', @plugin.controllers_path
  end
  
  def test_should_not_have_a_controllers_path_that_exists
    assert !@plugin.controllers_path?
  end
  
  def test_should_have_a_templates_path
    assert_equal '/path/to/plugin/app/views', @plugin.templates_path
  end
  
  def test_should_not_have_a_templates_path_that_exists
    assert !@plugin.templates_path?
  end
  
  def test_should_have_a_routes_path
    assert_equal '/path/to/plugin/routes.rb', @plugin.routes_path
  end
  
  def test_should_not_have_a_routes_path_that_exists
    assert !@plugin.routes_path?
  end
end

class PluginTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/basic_plugin")
  end
  
  def test_should_not_have_any_app_load_paths
    assert @plugin.app_load_paths.empty?
  end
  
  def test_should_only_include_lib_in_load_paths
    assert_equal ["#{@plugin.directory}/lib"], @plugin.load_paths
  end
end

class PluginAsAClassTest < Test::Unit::TestCase
  def test_should_be_able_to_find_all_template_paths
    expected = %w(users authenticated_users plugin_with_templates).collect {|plugin| "#{Rails.root}/vendor/plugins/#{plugin}/app/views"}
    assert_equal expected, Rails::Plugin.template_paths
  end
  
  def test_should_be_able_to_find_all_controller_paths
    expected = %w(users plugin_with_custom_paths plugin_with_namespaced_paths plugin_with_routes plugin_with_standard_paths).collect {|plugin| "#{Rails.root}/vendor/plugins/#{plugin}/app/controllers"}
    assert_equal expected, Rails::Plugin.controller_paths
  end
end

class PluginWithRoutesTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_routes")
  end
  
  def test_should_have_a_routes_path_that_exists
    assert @plugin.routes_path?
  end
end

class PluginWithEmptyAppPathTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_empty_app_path")
  end
  
  def test_should_not_have_any_app_load_paths
    assert @plugin.app_load_paths.empty?
  end
end

class PluginWithStandardPathsTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_standard_paths")
  end
  
  def test_should_have_a_controllers_path_that_exists
    assert @plugin.controllers_path?
  end
  
  def test_should_include_configured_paths_in_app_load_paths
    expected = %w(controllers models helpers).collect {|path| "#{@plugin.directory}/app/#{path}"}
    assert_equal expected, @plugin.app_load_paths
  end
  
  def test_should_include_app_load_paths_in_load_paths
    expected = %w(lib app/controllers app/models app/helpers).collect {|path| "#{@plugin.directory}/#{path}"}
    assert_equal expected, @plugin.load_paths
  end
end

class PluginWithCustomPathsTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_custom_paths")
  end
  
  def test_should_exclude_custom_paths_from_app_load_paths
    expected = %w(controllers models).collect {|path| "#{@plugin.directory}/app/#{path}"}
    assert_equal expected, @plugin.app_load_paths
  end
  
  def test_should_include_app_load_paths_in_load_paths
    expected = %w(lib app/controllers app/models).collect {|path| "#{@plugin.directory}/#{path}"}
    assert_equal expected, @plugin.load_paths
  end
end

class PluginWithNamespacedPathsTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_namespaced_paths")
  end
  
  def test_should_include_only_real_namespaced_in_app_load_paths
    expected = %w(app/controllers app/models app/models/fake_namespace).collect {|path| "#{@plugin.directory}/#{path}"}
    assert_equal expected, @plugin.app_load_paths
  end
end

class PluginWithTemplatesTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_templates")
  end
  
  def test_should_have_a_templates_path_that_exists
    assert @plugin.templates_path?
  end
end
end
