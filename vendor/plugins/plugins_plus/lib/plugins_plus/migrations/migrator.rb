module PluginAWeek #:nodoc:
  module PluginsPlus
    module Migrations
      # Responsible for migrating plugins.  +current_plugin+ indicates which plugin
      # is currently being migrated.
      class Migrator < ActiveRecord::Migrator
        # We need to be able to set the current plugin being migrated
        cattr_accessor :current_plugin
        
        class << self
          # Runs the migrations from a plugin, up (or down) to the version given
          def migrate_plugin(plugin, version = nil)
            self.current_plugin = plugin
            migrate(plugin.migration_path, version)
          end
          
          def schema_info_table_name #:nodoc:
            ActiveRecord::Base.table_name_prefix + 'plugin_schema_info' + ActiveRecord::Base.table_name_suffix
          end
          
          def current_version #:nodoc:
            current_plugin.current_version
          end
        end
        
        # Finds the version numbers that have already been migrated
        def migrated
          migrations.select {|migration| migration.version.to_i <= self.class.current_plugin.current_version}.map {|migration| migration.version.to_i}.sort
        end
        
        # Sets the version of the current plugin
        def record_version_state_after_migrating(version)
          plugin_name = ActiveRecord::Base.quote_value(current_plugin.name)
          if ActiveRecord::Base.connection.select_one("SELECT version FROM #{self.class.schema_info_table_name} WHERE plugin_name = #{plugin_name}")
            ActiveRecord::Base.connection.update("UPDATE #{self.class.schema_info_table_name} SET version = #{version} WHERE plugin_name = #{plugin_name}")
          else
            # We need to create the entry since it doesn't exist
            ActiveRecord::Base.connection.execute("INSERT INTO #{self.class.schema_info_table_name} (version, plugin_name) VALUES (#{version}, #{plugin_name})")
          end
        end
      end
    end
  end
end

ActiveRecord::SchemaDumper.ignore_tables << PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
