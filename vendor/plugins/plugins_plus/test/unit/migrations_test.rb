require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

module Migrations
class PluginByDefaultTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new('/path/to/plugin')
  end
  
  def test_should_be_at_version_zero
    assert_equal 0, @plugin.current_version
  end
  
  def test_should_have_a_migration_path
    assert_equal "/path/to/plugin/db/migrate", @plugin.migration_path
  end
  
  def test_should_have_a_fixtures_path
    assert_equal "/path/to/plugin/test/fixtures", @plugin.fixtures_path
  end
end

class PluginTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_migrations")
    setup_schema_information
  end
  
  def test_should_have_a_latest_version_the_same_as_latest_migration_available
    assert_equal 2, @plugin.latest_version
  end
  
  def test_should_migrate_to_latest_version_by_default
    @plugin.migrate
    
    assert Company.table_exists?
    assert Employee.table_exists?
    
    assert_equal 1, PluginSchemaInfo.count
    expected = [
      PluginSchemaInfo.new(:plugin_name => 'plugin_with_migrations', :version => 2)
    ]
    assert_equal expected, PluginSchemaInfo.find(:all)
  end
  
  def test_should_migrate_to_specific_version_if_version_specified
    @plugin.migrate(1)
    
    assert Company.table_exists?
    assert !Employee.table_exists?
    
    assert_equal 1, PluginSchemaInfo.count
    expected = [
      PluginSchemaInfo.new(:plugin_name => 'plugin_with_migrations', :version => 1)
    ]
    assert_equal expected, PluginSchemaInfo.find(:all)
    
    @plugin.migrate(0)
    
    assert !Company.table_exists?
    assert !Employee.table_exists?
    
    assert_equal 1, PluginSchemaInfo.count
    expected = [
      PluginSchemaInfo.new(:plugin_name => 'plugin_with_migrations', :version => 0)
    ]
    assert_equal expected, PluginSchemaInfo.find(:all)
  end
  
  def teardown
    teardown_schema_information
  end
end

class PluginWithNoMigrationTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_no_migrations")
    setup_schema_information
  end
  
  def test_should_have_a_latest_version_of_zero
    assert_equal 0, @plugin.latest_version
  end
  
  def teardown
    teardown_schema_information
  end
end

class PluginUpdateToDateTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_migrations")
    
    setup_schema_information
    PluginSchemaInfo.create(:plugin_name => 'plugin_with_migrations', :version => 2)
  end
  
  def test_should_be_at_version_last_migrated
    assert_equal 2, @plugin.current_version
  end
  
  def teardown
    teardown_schema_information
  end
end

class PluginWithFixturesTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_migrations")
    setup_schema_information
  end
  
  def test_should_include_all_fixtures_by_default
    expected = [
      "#{@plugin.fixtures_path}/companies.yml",
      "#{@plugin.fixtures_path}/employees.yml"
    ]
    assert_equal expected, @plugin.fixtures
  end
  
  def test_should_only_include_specific_fixtures_if_specified
    assert_equal ["#{@plugin.fixtures_path}/companies.yml"], @plugin.fixtures('companies')
    
    expected = [
      "#{@plugin.fixtures_path}/companies.yml",
      "#{@plugin.fixtures_path}/employees.yml"
    ]
    assert_equal expected, @plugin.fixtures('companies,employees')
  end
  
  def test_should_load_all_fixtures_by_default
    @plugin.migrate
    @plugin.load_fixtures
    
    assert_equal 1, Company.count
    assert_equal 2, Employee.count
  end
  
  def test_should_only_load_specific_fixtures_if_specified
    @plugin.migrate
    @plugin.load_fixtures('companies')
    
    assert_equal 1, Company.count
    assert_equal 0, Employee.count
  end
  
  def teardown
    Fixtures.reset_cache
    teardown_schema_information
  end
end
end
