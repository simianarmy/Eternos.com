# Id$
# 
# Module for Desktop Facebook App
# App implements:
#  Backup Content
#

require 'facebooker'

module FacebookDesktopApp
  mattr_accessor :config_path, :required_permissions
  @@config_path = File.join(RAILS_ROOT, 'config', 'facebooker_desktop.yml')
  @@required_permissions = %w( read_stream publish_stream offline_access )
  
  # Wrapper around Facebooker's load_configuration method - adds exception handling, 
  # default config file name
  class << self
    def load_config(path=nil)
      path = config_path if path.nil? || path.blank?
      raise "Unable to load #{path}" unless File.exist? path
      Facebooker.load_configuration(path)
    end
  end
  
  class Session < Facebooker::Session::Desktop
    attr_reader :config, :errors
    
    def self.create(config=nil)
      conf = FacebookDesktopApp.load_config(config)
      super(conf['api_key'], conf['secret_key'])
    end
    
    def connect(session, uid, timeout, secret)
      secure_with!(session, uid, timeout, secret)
    end

    # Returns login url + required permissions code
    def login_url_with_perms(options={})
      "http://www.facebook.com/login.php?api_key=#{self.class.api_key}&connect_display=popup&v=1.0&return_session=true&fbconnect=true&req_perms=#{FacebookDesktopApp.required_permissions.join(',')}#{add_next_parameters(options).join}"
    end
    
    # Checks if associated user can query 'friends' list.  If not, then session 
    # is incorrect (or secret key, or user doesn't exist anymore, etc.)
    def verify
      user.friends
      true
    rescue 
      @errors = $!
      false
    end
  end
end
    