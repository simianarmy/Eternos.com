# Id$
# 
# Module for Desktop Facebook App
# App implements:
#  Backup Content
#

require 'facebooker'

module FacebookDesktopApp
  mattr_accessor :config_path
  @@config_path = File.join(RAILS_ROOT, 'config', 'facebooker_desktop.yml')
  
  # Wrapper around Facebooker's load_configuration method - adds exception handling, 
  # default config file name
  class << self
    def load_config(path=config_path)
      raise "Unable to load #{path}: #{e.to_s}" unless File.exist? path
      Facebooker.load_configuration(path)
    end
  end
  
  class Session < Facebooker::Session::Desktop
    attr_reader :config
    
    def self.create
      FacebookDesktopApp.load_config
      super
    end
    
    def connect(session, uid, timeout, secret)
      secure_with!(session, uid, timeout, secret)
    end
  end
end
    