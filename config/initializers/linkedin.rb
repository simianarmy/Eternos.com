module Linkedin2
  class << self
    def load_config
      YAML.load(ERB.new(File.read(File.join(Rails.root,"config","linkedin.yml"))).result)[Rails.env]
    end
  end
end