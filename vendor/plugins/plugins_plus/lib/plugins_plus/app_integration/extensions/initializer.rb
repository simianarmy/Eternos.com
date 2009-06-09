module PluginAWeek #:nodoc:
  module PluginsPlus
    module AppIntegration
      module Extensions #:nodoc:
        # Adds support for add the possible controller/view paths for each
        # loaded plugin
        module Initializer
          def self.included(base) #:nodoc:
            base.class_eval do
              # Chain view initialization
              alias_method :initialize_framework_views_without_plugins_plus, :initialize_framework_views
              alias_method :initialize_framework_views, :initialize_framework_views_with_plugins_plus
              
              # Chain routing initialization
              alias_method :initialize_routing_without_plugins_plus, :initialize_routing
              alias_method :initialize_routing, :initialize_routing_with_plugins_plus
            end
          end
          
          # Adds the possible view paths for each loaded plugin
          def initialize_framework_views_with_plugins_plus
            initialize_framework_views_without_plugins_plus
            
            ActionController::Base.append_view_path(Rails::Plugin.template_paths.reverse)
          end
          
          # Adds the possible controller paths for each loaded plugin
          def initialize_routing_with_plugins_plus
            initialize_routing_without_plugins_plus
            
            ActionController::Routing.controller_paths.concat(Rails::Plugin.controller_paths)
          end
        end
      end
    end
  end
end

Rails::Initializer.class_eval do
  include PluginAWeek::PluginsPlus::AppIntegration::Extensions::Initializer
end
