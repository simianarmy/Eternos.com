module PluginAWeek #:nodoc:
  module PluginsPlus
    module Migrations
      module Extensions #:nodoc:
        # Adds support for the plugin schema info table
        module SchemaStatements
          def self.included(base) #:nodoc:
            base.class_eval do
              alias_method_chain :initialize_schema_migrations_table, :plugins
            end
          end
          
          # Creates the plugin schema info table
          def initialize_schema_migrations_table_with_plugins
            initialize_schema_migrations_table_without_plugins
            
            table_name = PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name
            
            # Make sure the schema hasn't already been initialized
            unless tables.detect {|t| t == table_name}
              execute "CREATE TABLE #{table_name} (plugin_name #{type_to_sql(:string)}, version #{type_to_sql(:integer)})"
            end
          end
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.class_eval do
  include PluginAWeek::PluginsPlus::Migrations::Extensions::SchemaStatements
end
