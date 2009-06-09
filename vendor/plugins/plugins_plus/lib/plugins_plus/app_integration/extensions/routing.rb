module PluginAWeek #:nodoc:
  module PluginsPlus
    module AppIntegration
      module Extensions #:nodoc:
        # Adds support for route generation
        module Routing
          # Loads the set of routes from within a plugin and evaluates them at this
          # point within an application's main <tt>routes.rb</tt> file.
          #
          # Plugin routes are loaded from <tt><plugin_root>/routes.rb</tt>.
          # 
          # If the plugin or its associated routes cannot be found, an exception
          # will be raised.
          # 
          # == Examples
          # 
          # routes.rb:
          #   ActionController::Routing::Routes.draw do |map|
          #     ...
          #     map.from_plugin :users
          #     ...
          #   end
          def from_plugin(name)
            if plugin = Rails::Plugin.find(name)
              if plugin.routes_path?
                eval(IO.read(plugin.routes_path), binding, plugin.routes_path)
              else
                raise MissingSourceFile.new("No routes defined for plugin \"#{name}\"", 'routes.rb')
              end
            else
              raise MissingSourceFile.new("No such plugin: #{name}", name)
            end
          end
        end
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.class_eval do
  include PluginAWeek::PluginsPlus::AppIntegration::Extensions::Routing
end
