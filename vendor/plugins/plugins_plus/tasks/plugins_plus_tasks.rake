namespace :assets do
  desc 'Lists all plugin assets. Target specific plugin with PLUGIN=x'
  task :list => :environment do
    PluginAWeek::PluginsPlus::Assets.list(ENV['PLUGIN']).each do |plugin, assets|
      puts "\n#{plugin}:"
      puts assets
    end
  end
  
  desc "Copies plugin assets to your application's public/ folder. Target specific plugin with PLUGIN=x"
  task :copy => :environment do
    PluginAWeek::PluginsPlus::Assets.copy(ENV['PLUGIN'])
  end
  
  desc "Updates plugin assets in your application's public/ folder. Existing files will not be overwritten. Target specific plugin with PLUGIN=x"
  task :update => :environment do
    PluginAWeek::PluginsPlus::Assets.update(ENV['PLUGIN'])
  end
end
