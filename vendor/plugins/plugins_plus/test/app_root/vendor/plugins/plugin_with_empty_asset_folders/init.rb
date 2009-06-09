# If loaded as a gem
javascripts_dir = "#{File.dirname(__FILE__)}/assets/javascripts"
FileUtils.mkdir_p(javascripts_dir) unless File.directory?(javascripts_dir)
