# $Id$
require 'app_config'

class AppConfig
  def self.[](key)
    self.send key
  end
  
  def self.[]=(key, value)
    self.send("#{key}=", value)
  end
end

AppConfig.load