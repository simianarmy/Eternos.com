require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

require 'rails_generator'

# Add the plugin_migrations generators since it's not in the normal vendor/plugins path
Rails::Generator::Base.sources << Rails::Generator::PathSource.new(:plugin_migrations, "#{Rails.root}/../../generators")

Rails::Generator::Commands::Base.class_eval do
  def migration_directory(relative_path)
    directory(relative_path)
    @migration_directory = "#{Rails.root}/#{relative_path}"
  end
end

class PluginMigrationGeneratorTest < Test::Unit::TestCase
  def setup
    @db_root = "#{Rails.root}/db"
    FileUtils.cp_r("#{Rails.root}/db_bak", @db_root)
  end
  
  def test_should_throw_exception_if_plugin_doesnt_exist
    assert_raise(ArgumentError) {generate('invalid')}
  end
  
  def test_should_throw_exception_if_plugin_migration_already_created_for_latest_version
    assert_raise(RuntimeError) {generate('plugin_with_migrations')}
  end
  
  def test_should_create_migration_for_plugin_never_migrated_before
    FileUtils.rm("#{@db_root}/migrate/002_migrate_second_plugin_with_migrations_to_version_1.rb")
    
    generate('second_plugin_with_migrations')
    migration_path = Dir["#{@db_root}/migrate/*.rb"].sort.last
    assert File.exists?(migration_path)
    
    expected = <<-EOS
class MigrateSecondPluginWithMigrationsToVersion3 < ActiveRecord::Migration
  def self.up
    Rails::Plugin.find(:second_plugin_with_migrations).migrate(3)
  end

  def self.down
    Rails::Plugin.find(:second_plugin_with_migrations).migrate(0)
  end
end

EOS
    assert_equal expected, File.read(migration_path)
  end
  
  def test_should_create_migration_for_plugin_previously_migrated
    Rails::Plugin.new("#{Rails.root}/vendor/plugins/second_plugin_with_migrations").migrate(1)
    
    generate('second_plugin_with_migrations')
    migration_path = Dir["#{@db_root}/migrate/*.rb"].sort.last
    assert File.exists?(migration_path)
    
    expected = <<-EOS
class MigrateSecondPluginWithMigrationsToVersion3 < ActiveRecord::Migration
  def self.up
    Rails::Plugin.find(:second_plugin_with_migrations).migrate(3)
  end

  def self.down
    Rails::Plugin.find(:second_plugin_with_migrations).migrate(1)
  end
end

EOS
    assert_equal expected, File.read(migration_path)
  end
  
  def teardown
    FileUtils.rm_rf(@db_root)
  end
  
  private
    def generate(plugin)
      Rails::Generator::Base.instance('plugin_migration', [plugin]).command(:create).invoke!
    end
end
