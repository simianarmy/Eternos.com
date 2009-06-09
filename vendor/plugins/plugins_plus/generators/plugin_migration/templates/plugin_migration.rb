class <%= class_name %> < ActiveRecord::Migration
  def self.up
    Rails::Plugin.find(:<%= plugin.name %>).migrate(<%= plugin.latest_version %>)
  end

  def self.down
    Rails::Plugin.find(:<%= plugin.name %>).migrate(<%= plugin.current_version %>)
  end
end

