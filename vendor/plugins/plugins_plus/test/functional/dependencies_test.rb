require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class DependencyLoadPathsTest < Test::Unit::TestCase
  def test_should_include_plugin_app_paths_in_load_path
    expected = [File.expand_path('.') + '/lib'] + %w(
      plugin_with_standard_paths/app/helpers
      plugin_with_standard_paths/app/models
      plugin_with_standard_paths/app/controllers
      plugin_with_standard_paths/lib
      plugin_with_routes/app/controllers
      plugin_with_namespaced_paths/app/models/fake_namespace
      plugin_with_namespaced_paths/app/models
      plugin_with_namespaced_paths/app/controllers
      plugin_with_custom_paths/app/models
      plugin_with_custom_paths/app/controllers
      plugin_with_custom_paths/lib
      basic_plugin/lib
      authenticated_users/app/models
      users/app/models
      users/app/controllers
    ).collect {|path| "#{Rails.root}/vendor/plugins/#{path}"}
    lib_index = $LOAD_PATH.index("#{Rails.root}/lib")
    
    assert_equal expected, $LOAD_PATH[lib_index + 1..lib_index + expected.size]
  end
  
  def test_should_include_plugin_app_paths_in_load_paths
    expected = %w(
      users/app/controllers
      users/app/models
      authenticated_users/app/models
      basic_plugin/lib
      plugin_with_custom_paths/lib
      plugin_with_custom_paths/app/controllers
      plugin_with_custom_paths/app/models
      plugin_with_namespaced_paths/app/controllers
      plugin_with_namespaced_paths/app/models
      plugin_with_namespaced_paths/app/models/fake_namespace
      plugin_with_routes/app/controllers
      plugin_with_standard_paths/lib
      plugin_with_standard_paths/app/controllers
      plugin_with_standard_paths/app/models
      plugin_with_standard_paths/app/helpers
    ).collect {|path| "#{Rails.root}/vendor/plugins/#{path}"} + [File.expand_path('.') + '/lib']
    separator_index = Dependencies.load_paths.index("#{Rails.root}/app/models/fake_namespace")
    
    assert_equal expected, Dependencies.load_paths[separator_index + 1..separator_index + expected.size]
  end
  
  def test_should_include_plugin_app_paths_in_load_once_paths
    expected = %w(
      users/app/controllers
      users/app/models
      authenticated_users/app/models
      basic_plugin/lib
      plugin_with_custom_paths/lib
      plugin_with_custom_paths/app/controllers
      plugin_with_custom_paths/app/models
      plugin_with_namespaced_paths/app/controllers
      plugin_with_namespaced_paths/app/models
      plugin_with_namespaced_paths/app/models/fake_namespace
      plugin_with_routes/app/controllers
      plugin_with_standard_paths/lib
      plugin_with_standard_paths/app/controllers
      plugin_with_standard_paths/app/models
      plugin_with_standard_paths/app/helpers
    ).collect {|path| "#{Rails.root}/vendor/plugins/#{path}"} + [File.expand_path('.') + '/lib']
    
    assert_equal expected, Dependencies.load_once_paths
  end
end

class DependenciesTest < Test::Unit::TestCase
  def test_should_load_model_from_plugin
    assert AuthenticatedUser
  end
  
  def test_should_load_controller_from_plugin
    assert UsersController
  end
  
  def test_should_load_from_last_loaded_plugin_if_in_multiple_plugins
    assert User
    assert_equal 'users', User.loader
  end
  
  def test_should_load_model_from_app
    assert Article
  end
  
  def test_should_load_controller_from_app
    assert SiteController
  end
  
  def test_should_load_from_app_if_in_app_and_plugin
    assert Session
    assert_equal 'app', Session.loader
  end
end
