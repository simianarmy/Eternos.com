require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class PluginsPlusTest < Test::Unit::TestCase
  def test_should_be_verbose
    assert PluginAWeek::PluginsPlus.verbose
  end
end

class PluginAsAClassTest < Test::Unit::TestCase
  def test_should_be_able_to_find_all_plugins
    expected = %w(
      users
      authenticated_users
      basic_plugin
      calendar
      gallery
      graphing
      plugin_with_custom_paths
      plugin_with_empty_app_path
      plugin_with_empty_asset_folders
      plugin_with_empty_assets
      plugin_with_migrations
      plugin_with_namespaced_paths
      plugin_with_no_db
      plugin_with_no_migrations
      plugin_with_routes
      plugin_with_standard_paths
      plugin_with_templates
      plugin_without_assets
      plugins_plus
      second_plugin_with_migrations
    )
    assert_equal expected, Rails::Plugin.find(:all).map(&:name)
  end
  
  def test_should_be_able_to_find_a_specific_plugin_with_symbol
    assert_equal 'basic_plugin', Rails::Plugin.find(:basic_plugin).name
  end
  
  def test_should_be_able_to_find_a_specific_plugin_with_string
    assert_equal 'basic_plugin', Rails::Plugin.find('basic_plugin').name
  end
  
  def test_should_return_nil_if_plugin_not_found
    assert_nil Rails::Plugin.find(:invalid)
  end
  
  def test_should_be_able_to_find_multiple_plugins
    assert_equal %w(calendar gallery), Rails::Plugin.find(%w(calendar gallery)).map(&:name)
  end
end
