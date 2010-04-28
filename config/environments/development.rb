# $Id$
# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
#config.action_mailer.raise_delivery_errors = false
# Care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

FACEBOOK_TUNNELLING = false

config.action_controller.asset_host = Proc.new { |source, request|
  # Handle facebook tunneling crazyiness
  if FACEBOOK_TUNNELLING
    port = request ? request.port : nil
    if port && (port == 4007)
      port = 3001
    end
  end
  (request ? request.protocol : 'http://') + 
  (request ? request.host : 'dev.eternos.com') + 
  ((port && FACEBOOK_TUNNELLING) ? ':' + port.to_s : "")
}

# Use SMTP protocol to deliver emails
config.action_mailer.delivery_method = :smtp

config.after_initialize do
  require 'bullet'
  Bullet.enable = true 
  Bullet.alert = false
  Bullet.bullet_logger = true  
  Bullet.console = true
  Bullet.growl = true
  Bullet.rails_logger = true
  Bullet.disable_browser_cache = true

  begin
    require 'ruby-growl'
    Bullet.growl = true
  rescue MissingSourceFile
  end
    
  # For debugging with Passenger
  if File.exists?(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
    require 'ruby-debug'
    Debugger.wait_connection = true
    Debugger.start_remote
    File.delete(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
  end

  # For fancy activerecord table views in irb/console
  require 'hirb'
  Hirb::View.enable
  
  # So that Passenger can find the identify command
  Paperclip.options[:command_path] = "/opt/local/bin"
  
  # monkey patch for memcache-client 'undefined class/module' errors in dev mode
  # 
  # Marshal.load is a C-method built into Ruby; because it's so low-level, it
  # bypasses the full classloading chain in Ruby, in particular the #const_missing
  # hook that Rails uses to auto-load classes as they're referenced. This monkey
  # patch catches the generated exceptions, parses the message to determine the
  # offending constant name, loads the constant, and tries again.
  #
  # This solution is adapted from here:
  # http://kballcodes.com/2009/09/05/rails-memcached-a-better-solution-to-the-undefined-classmodule-problem/
  #
  # THIS FUCKS EVERYTHING UP FOR BACKUP DAEMON & FACEBOOK - FIND ALTERNATIVE
  # if defined?(PhusionPassenger)
  #     class <<Marshal
  #       def load_with_rails_classloader(*args)
  #         begin
  #           load_without_rails_classloader(*args)
  #         rescue ArgumentError, NameError => e
  #           if e.message =~ %r(undefined class/module)
  #             const = e.message.split(' ').last
  #             const.constantize
  #             retry
  #           else
  #             raise(e)
  #           end
  #         end
  #       end
  # 
  #       alias_method_chain :load, :rails_classloader
  #     end
  #end
end

