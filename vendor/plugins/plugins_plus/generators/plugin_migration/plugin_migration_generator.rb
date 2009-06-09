# Creates a new migration for a given plugin
class PluginMigrationGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
    
    plugin_name = runtime_args.first
    plugin = Rails::Plugin.find(plugin_name) || raise(ArgumentError, "Couldn't find plugin: #{plugin_name}")
    migration_name = "migrate_#{plugin.name}_to_version_#{plugin.latest_version}"
    @options = {:assigns => {}}
    @options[:migration_file_name] = migration_name
    @options[:assigns][:class_name] = migration_name.classify
    @options[:assigns][:plugin] = plugin
  end
  
  def manifest
    record do |m|
      m.migration_template 'plugin_migration.rb', 'db/migrate', @options
    end
  end
end
