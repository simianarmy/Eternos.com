module PluginAWeek #:nodoc:
  module PluginsPlus
    # Adds support for keeping your application's assets up-to-date with the
    # latest assets in your plugins.
    # 
    # Assets are files like images, css, js, etc. that are used on the website.
    # They are essentially the same types of files you would find in your
    # application's public/ folder.
    # 
    # By default, all files and folders that are created/updated will be written
    # to standard out as it happens.  You can quiet this down by setting
    # PluginAWeek::PluginsPlus.verbose = false.
    module Assets
      class << self
        # Lists all current assets in the specified plugins.  If no plugins are
        # specified, then all plugin assets will be listed.
        def list(plugin_names = '')
          find_plugins(plugin_names).inject([]) do |assets, plugin|
            assets << [plugin.name, plugin.assets] if plugin.assets.any?
            assets
          end
        end
        
        # Copies assets from the specified plugins to your application's public/
        # folder.  If no plugins are specified, then all plugin assets will be copied.
        def copy(plugin_names = '')
          find_plugins(plugin_names).each {|plugin| plugin.copy_assets}
        end
        
        # Updates assets from the specified plugins in your application's public/
        # folder. Existing files will not be overwritten.  If no plugins are
        # specified, then all plugin assets will be updated.
        def update(plugin_names = '')
          find_plugins(plugin_names).each {|plugin| plugin.update_assets}
        end
        
        # Finds plugins with the given names
        def find_plugins(plugin_names)
          Rails::Plugin.find(plugin_names.blank? ? :all : plugin_names.split(','))
        end
      end
      
      # The path of the plugin's assets
      def source_assets_path
        "#{directory}/assets"
      end
      
      # The target path to copy the plugin's assets to
      def target_assets_path(type)
        "#{Rails.root}/public/#{type}"
      end
      
      # A list of all the plugin's assets (files and directories), sorted
      # alphabetically
      def assets
        Dir["#{source_assets_path}/**/*"].sort
      end
      
      # A list of the plugin's asset files
      def asset_files
        assets.select {|d| !File.directory?(d)}
      end
      
      # A list of the plugin's asset directories
      def asset_directories
        assets.select {|d| File.directory?(d)}
      end
      
      # Copies all assets, overwriting any that exist
      def copy_assets
        update_assets(true)
      end
      
      # Updates the plugin's assets, optionally overwriting any existing ones
      def update_assets(overwrite = false)
        return unless File.exists?(source_assets_path)
        
        puts "\nMirroring assets for #{name}:" if PluginAWeek::PluginsPlus.verbose
        
        # Create all the target directories and update the asset files
        directories_written = create_asset_directories
        files_written = update_asset_files(overwrite)
        
        puts 'No new assets found' if !(directories_written || files_written) && PluginAWeek::PluginsPlus.verbose
      end
      
      private
        # Creates all of the target asset directories that will be written to (skips
        # any that already exist)
        def create_asset_directories
          directories_written = false
          
          asset_directories.each do |dir|
            target = target_asset_file(dir)
            
            unless File.exist?(target)
              puts "create #{target}..." if PluginAWeek::PluginsPlus.verbose
              FileUtils.mkdir_p(target)
              puts 'done' if PluginAWeek::PluginsPlus.verbose
              
              directories_written = true
            end
          end
          
          directories_written
        end
        
        def update_asset_files(overwrite)
          files_written = false
          
          asset_files.each do |file|
            target = target_asset_file(file)
            target_exists = File.exist?(target)
            
            # We do not overwrite the file if the file exists and (1) is identical
            # or (2) we're allowed to overwrite the file
            unless target_exists && (FileUtils.identical?(file, target) || !overwrite)
              action = target_exists ? 'update' : 'create'
              
              puts "#{action} #{target} ..." if PluginAWeek::PluginsPlus.verbose
              FileUtils.cp(file, target)
              puts 'done' if PluginAWeek::PluginsPlus.verbose
              
              files_written = true
            end 
          end
          
          files_written
        end
        
        # Gets the path of the target that should be created based on the specified
        # source file
        def target_asset_file(source_file)
          target_file = source_file.sub(/#{Regexp.escape(source_assets_path)}\/([^\/]+)/, '')
          asset_type = $1
          
          target_path = target_assets_path(asset_type)
          target_file.empty? ? target_path : File.join(target_path, target_file)
        end
    end
  end
end
