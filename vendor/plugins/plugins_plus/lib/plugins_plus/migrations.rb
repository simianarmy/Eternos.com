module PluginAWeek #:nodoc:
  module PluginsPlus
    # Adds support for loading fixtures from and migrating plugins
    module Migrations
      class << self
        # Loads ActiveRecord extensions
        def init
          require 'plugins_plus/migrations/extensions/schema_statements'
          require 'plugins_plus/migrations/migrator'
        end
      end
      
      # The location of the plugin's migrations
      def migration_path
        "#{directory}/db/migrate"
      end
      
      # The current version of the plugin migrated in the database
      def current_version
        begin
          if result = ActiveRecord::Base.connection.select_one("SELECT version FROM #{PluginAWeek::PluginsPlus::Migrations::Migrator.schema_info_table_name} WHERE plugin_name = #{ActiveRecord::Base.quote_value(name)}")
            result['version'].to_i
          else
            # There probably isn't an entry for this plugin in the migration info table.
            0
          end
        rescue ActiveRecord::StatementInvalid
          # No migraiton info table, so never migrated
          0
        end
      end
      
      # The latest version of the plugin according to the current migrations
      def latest_version
        migrations = Dir["#{migration_path}/[0-9]*_[_a-z0-9]*.rb"]
        migrations.map {|migration| File.basename(migration).match(/^([0-9]+)/)[1].to_i}.max || 0
      end
      
      # Migrate this plugin to the given version
      def migrate(version = nil)
        PluginAWeek::PluginsPlus::Migrations::Migrator.migrate_plugin(self, version)
      end
      
      # The location of the plugin's fixtures
      def fixtures_path
        "#{directory}/test/fixtures"
      end
      
      # The paths of all of the plugin's fixtures
      def fixtures(names = nil)
        names ||= '*'
        Dir["#{fixtures_path}/{#{names}}.{yml,csv}"].sort
      end
      
      # Loads the fixtures for the plugin
      def load_fixtures(*args)
        fixtures(*args).each do |fixture|
          Fixtures.create_fixtures(File.dirname(fixture), File.basename(fixture, '.*'))
        end
      end
    end
  end
end
