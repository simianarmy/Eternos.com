require 'plugins_plus/assets'
require 'plugins_plus/migrations'
require 'plugins_plus/app_integration'

module PluginAWeek
  # Provides various utilities for extend the capabilities of plugins
  module PluginsPlus
    # Whether detailed debugging output should be enabled
    @verbose = true
    class << self; attr_accessor :verbose; end
    
    class << self
      # Loads any extensions that can only be done during the initialization
      # process
      def init
        PluginAWeek::PluginsPlus::Migrations.init
        PluginAWeek::PluginsPlus::AppIntegration.init
      end
      
      def included(base) #:nodoc:
        base.class_eval do
          include PluginAWeek::PluginsPlus::Assets
          include PluginAWeek::PluginsPlus::Migrations
          include PluginAWeek::PluginsPlus::AppIntegration
          
          extend PluginAWeek::PluginsPlus::ClassMethods
        end
      end
    end
    
    module ClassMethods
      # Finds one or more plugins.
      # 
      # To find all plugins:
      #   Rails::Plugin.find(:all)
      # 
      # To find a single plugin:
      #   Rails::Plugin.find(:plugin_name)
      # 
      # To find more than one plugin:
      #   Rails::Plugin.find([:plugin_name, :other_plugin_name])
      def find(name)
        plugins = Rails.configuration.plugin_loader.new(Rails::Initializer.new(Rails.configuration)).plugins
        
        if name.is_a?(Symbol) || name.is_a?(String)
          if name != :all
            name = name.to_s
            plugins = plugins.find {|plugin| plugin.name == name}
          end
        else
          name = name.map(&:to_s)
          plugins.delete_if {|plugin| !name.include?(plugin.name)}
        end
        
        plugins
      end
    end
  end
end

Rails::Plugin.class_eval do
  include PluginAWeek::PluginsPlus
end
