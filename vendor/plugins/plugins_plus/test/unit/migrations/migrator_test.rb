require File.expand_path("#{File.dirname(__FILE__)}/../../test_helper")

module Migrations
class MigratorTest < Test::Unit::TestCase
  def setup
    setup_schema_information
  end
  
  def test_schema_info_table_name_should_not_have_prefix_or_suffix
    assert_equal 'plugin_schema_info', PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
  end
  
  def test_schema_info_table_name_should_have_prefix_if_prefix_exists
    ActiveRecord::Base.table_name_prefix = 'prefix_'
    assert_equal 'prefix_plugin_schema_info', PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
  end
  
  def test_schema_info_table_name_should_have_suffix_if_suffix_exists
    ActiveRecord::Base.table_name_suffix = '_suffix'
    assert_equal 'plugin_schema_info_suffix', PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
  end
  
  def test_schema_info_table_name_should_have_prefix_and_suffix_if_both_exist
    ActiveRecord::Base.table_name_prefix = 'prefix_'
    ActiveRecord::Base.table_name_suffix = '_suffix'
    assert_equal 'prefix_plugin_schema_info_suffix', PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
  end
  
  def test_schema_info_table_name_should_be_ignored_by_schema_dumper
    assert ActiveRecord::SchemaDumper.ignore_tables.include?('plugin_schema_info')
  end
  
  def teardown
    ActiveRecord::Base.table_name_prefix = ''
    ActiveRecord::Base.table_name_suffix = ''
    teardown_schema_information
  end
end

class MigratorWithNewPluginTest < Test::Unit::TestCase
  def setup
    setup_schema_information
    PluginAWeek::PluginsPlus::Migrations::Migrator.current_plugin = Rails::Plugin.new('/path/to/test_plugin')
  end
  
  def test_should_be_at_version_zero
    assert_equal 0, PluginAWeek::PluginsPlus::Migrations::Migrator.current_version
    assert_equal 0, PluginSchemaInfo.count
  end
  
  def test_should_not_have_any_migrated_versions
    migrator = PluginAWeek::PluginsPlus::Migrations::Migrator.allocate
    assert migrator.migrated.empty?
  end
  
  def teardown
    teardown_schema_information
  end
end

class MigratorWithExistingPluginTest < Test::Unit::TestCase
  class MigrateToVersion1 < ActiveRecord::Migration
    def self.version
      1
    end
  end
  
  class MigrateToVersion2 < ActiveRecord::Migration
    def self.version
      2
    end
  end
  
  def setup
    setup_schema_information
    PluginAWeek::PluginsPlus::Migrations::Migrator.current_plugin = Rails::Plugin.new('/path/to/test_plugin')
    @migrator = PluginAWeek::PluginsPlus::Migrations::Migrator.allocate
    @migrator.record_version_state_after_migrating(1)
  end
  
  def test_should_update_existing_plugin_schema_info
    assert_equal 1, PluginAWeek::PluginsPlus::Migrations::Migrator.current_version
    assert_equal 1, PluginSchemaInfo.count
    
    PluginAWeek::PluginsPlus::Migrations::Migrator.allocate.record_version_state_after_migrating(2)
    assert_equal 2, PluginAWeek::PluginsPlus::Migrations::Migrator.current_version
    assert_equal 1, PluginSchemaInfo.count
  end
  
  def teardown
    teardown_schema_information
  end
end
end
