require 'config/boot'
require File.expand_path('.') + '/boot'

Rails::Initializer.run do |config|
  config.load_paths.concat(
    Dir["#{Rails.root}/app/mailers/**/"] +
    ["#{Rails.root}/app/models/fake_namespace"]
  )
  config.plugins = %w(users authenticated_users) + [:all] # Make sure we're loaded *first*
  config.cache_classes = false
  config.whiny_nils = true
end
