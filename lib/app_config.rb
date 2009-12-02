# $Id$
class AppConfig  
  def self.load
    config_file = File.join(Rails.root, "config", "application.yml")
    puts "*** Loading AppConfig config: #{config_file}"
    if File.exists?(config_file)
      config = YAML.load(File.read(config_file))[RAILS_ENV]
      if !config.nil?
        config.keys.each do |key|
          cattr_accessor key
          send("#{key}=", config[key])
        end
      end
    end
  end
end
