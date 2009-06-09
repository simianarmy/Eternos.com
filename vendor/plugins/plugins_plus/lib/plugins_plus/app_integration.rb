require 'plugins_plus/app_integration/extensions/initializer'

module PluginAWeek #:nodoc:
  module PluginsPlus
    # Adds support for integrating models, controllers, and views into the
    # core application's code.
    module AppIntegration
      class << self
        # Loads routing and mailer extensions
        def init
          require 'plugins_plus/app_integration/extensions/routing'
          require 'plugins_plus/app_integration/extensions/action_mailer' if defined?(ActionMailer::Base)
        end
        
        def included(base) #:nodoc:
          base.class_eval do
            extend PluginAWeek::PluginsPlus::AppIntegration::ClassMethods
            
            alias_method :load_paths_without_app_integration, :load_paths
            alias_method :load_paths, :load_paths_with_app_integration
          end
        end
      end
      
      module ClassMethods
        # Gets all of the valid template paths within the loaded plugins
        def template_paths
          find(:all).inject([]) do |paths, plugin|
            paths << plugin.templates_path if plugin.templates_path?
            paths
          end
        end
        
        # Gets all of the valid controller paths within the loaded plugins
        def controller_paths
          find(:all).inject([]) do |paths, plugin|
            paths << plugin.controllers_path if plugin.controllers_path?
            paths
          end
        end
      end
      
      # The path to the plugin's app directory
      def app_path
        "#{directory}/app"
      end
      
      # Gets a list of additional load paths within the plugin's app path
      def app_load_paths
        # Find paths configured for the app
        configured_paths = Rails.configuration.load_paths.select {|path| path =~ /#{Rails.configuration.root_path}\/app\//}
        
        # Remove duplicate paths
        configured_paths.collect! {|path| path.ends_with?('/') ? path.chop : path}.uniq!
        
        # Convert to paths relative to the plugin
        configured_paths.collect! {|path| path.gsub(Rails.configuration.root_path, directory)}
        
        # Remove paths that don't exist
        configured_paths.delete_if {|path| !File.directory?(path)}
      end
      
      # Gets the plugin's load paths
      def load_paths_with_app_integration
        load_paths_without_app_integration + app_load_paths
      end
      
      # The path to the controllers for this plugin
      def controllers_path
        "#{app_path}/controllers"
      end
      
      # Does the plugin actually define controllers?
      def controllers_path?
        File.exists?(controllers_path)
      end
      
      # The path to the views for this plugin
      def templates_path
        "#{directory}/app/views"
      end
      
      # Does the plugin actually define templates?
      def templates_path?
        File.exists?(templates_path)
      end
      
      # The path to the plugin's routes
      def routes_path
        "#{directory}/routes.rb"
      end
      
      # Does the plugin actually define routes?
      def routes_path?
        File.exists?(routes_path)
      end
    end
  end
end
