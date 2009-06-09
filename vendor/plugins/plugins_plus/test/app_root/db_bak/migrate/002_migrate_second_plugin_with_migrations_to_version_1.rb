class MigrateSecondPluginWithMigrationsToVersion1 < ActiveRecord::Migration
  def self.up
    Rails::Plugins.find(:second_plugin_with_migrations).migrate(1)
  end
  
  def self.down
    Rails::Plugins.find(:second_plugin_with_migrations).migrate(0)
  end
end
