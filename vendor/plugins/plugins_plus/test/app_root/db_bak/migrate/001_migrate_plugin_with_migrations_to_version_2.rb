class MigratePluginWithMigrationsToVersion2 < ActiveRecord::Migration
  def self.up
    Rails::Plugin.find(:plugin_with_migrations).migrate(2)
  end
  
  def self.down
    Rails::Plugins.find(:plugin_with_migrations).migrate(0)
  end
end
