module PluginAWeek #:nodoc:
  module PluginsPlus
    module AppIntegration
      module Extensions #:nodoc:
        # Add support for mail templates
        module ActionMailer
          def self.included(base) #:nodoc:
            base.class_eval do
              alias_method_chain :template_path, :plugin_routing
              alias_method :initialize_template_class_without_helper, :initialize_template_class_with_plugin_routing
            end
          end
          
          # Includes possible template paths from all plugins
          def template_path_with_plugin_routing
            template_paths = [template_path_without_plugin_routing] + Rails::Plugin.template_paths.reverse.map {|path| "#{path}/#{mailer_name}"}
            "{#{template_paths * ','}}"
          end
          
          def initialize_template_class_with_plugin_routing(assigns) #:nodoc:
            ActionView::Base.new([template_root] + Rails::Plugin.template_paths.reverse, assigns, self)
          end
        end
      end
    end
  end
end

ActionMailer::Base.class_eval do
  include PluginAWeek::PluginsPlus::AppIntegration::Extensions::ActionMailer
end
