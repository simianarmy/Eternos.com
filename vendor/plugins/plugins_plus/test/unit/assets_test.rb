require "#{File.dirname(__FILE__)}/../test_helper"

module Assets
class PluginTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new('/path/to/plugin')
  end
  
  def test_should_have_source_assets_path
    assert_equal '/path/to/plugin/assets', @plugin.source_assets_path
  end
  
  def test_should_target_public_root_for_assets
    assert_equal "#{Rails.root}/public/images", @plugin.target_assets_path('images')
  end
end

class PluginWithAssetsTest < Test::Unit::TestCase
  def setup
    @path = "#{Rails.root}/vendor/plugins/graphing"
    @plugin = Rails::Plugin.new(@path)
    
    setup_public_assets
  end
  
  def test_should_have_assets
    expected = [
      'images',
      'images/dot.gif',
      'stylesheets',
      'stylesheets/graphs.css'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.assets
  end
  
  def test_should_only_include_files_in_asset_files
    expected = [
      'images/dot.gif',
      'stylesheets/graphs.css'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.asset_files
  end
  
  def test_should_only_include_directories_in_asset_directories
    expected = [
      'images',
      'stylesheets'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.asset_directories
  end
  
  def test_should_write_missing_assets_after_update
    @plugin.update_assets
    
    expected = [
      'images',
      'images/blank.gif',
      'images/dot.gif',
      'stylesheets',
      'stylesheets/graphs.css'
    ].collect! {|path| "#{@public_root}/#{path}"}
    
    assert_equal expected, current_public_files
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginWithAssetSubdirectoriesTest < Test::Unit::TestCase
  def setup
    @path = "#{Rails.root}/vendor/plugins/calendar"
    @plugin = Rails::Plugin.new(@path)
    
    setup_public_assets
  end
  
  def test_should_include_assets_within_subdirectories
    expected = [
      'javascripts',
      'javascripts/jscalendar',
      'javascripts/jscalendar/core.js',
      'stylesheets',
      'stylesheets/jscalendar.css'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.assets
  end
  
  def test_should_include_subdirectory_files_in_asset_files
    expected = [
      "javascripts/jscalendar/core.js",
      "stylesheets/jscalendar.css"
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.asset_files
  end
  
  def test_should_include_subdirectories_in_asset_directories
    expected = [
      'javascripts',
      'javascripts/jscalendar',
      'stylesheets'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.asset_directories
  end
  
  def test_should_write_missing_assets_after_update
    @plugin.update_assets
    
    expected = [
      'images',
      'images/blank.gif',
      'javascripts',
      'javascripts/jscalendar',
      'javascripts/jscalendar/core.js',
      'stylesheets',
      'stylesheets/jscalendar.css'
    ].collect! {|path| "#{@public_root}/#{path}"}
    
    assert_equal expected, current_public_files
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginWithEmptyAssetFoldersTest < Test::Unit::TestCase
  def setup
    @path = "#{Rails.root}/vendor/plugins/plugin_with_empty_asset_folders"
    @plugin = Rails::Plugin.new(@path)
  end
  
  def test_should_include_empty_directories_in_asset_directories
    expected = [
      'javascripts'
    ].collect! {|path| "#{@path}/assets/#{path}"}
    
    assert_equal expected, @plugin.asset_directories
  end
end

class PluginWithEmptyAssetsTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_with_empty_assets")
    
    setup_public_assets
  end
  
  def test_should_not_have_any_asset_files
    assert_equal [], @plugin.asset_files
  end
  
  def test_should_not_have_any_asset_directories
    assert_equal [], @plugin.asset_directories
  end
  
  def test_should_not_write_any_files_after_updating_assets
    @plugin.update_assets
    assert_equal @original_public_files, current_public_files
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginWithNoAssetsTest < Test::Unit::TestCase
  def setup
    @plugin = Rails::Plugin.new("#{Rails.root}/vendor/plugins/plugin_without_assets")
    
    setup_public_assets
  end
  
  def test_should_not_have_any_asset_files
    assert_equal [], @plugin.asset_files
  end
  
  def test_should_not_have_any_asset_directories
    assert_equal [], @plugin.asset_directories
  end
  
  def test_should_not_update_assets_if_assets_directory_doesnt_exist
    @plugin.update_assets
    assert_equal @original_public_files, current_public_files
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginWithExistingAssetsTest < Test::Unit::TestCase
  def setup
    @path = "#{Rails.root}/vendor/plugins/gallery"
    @plugin = Rails::Plugin.new(@path)
    
    setup_public_assets
  end
  
  def test_should_not_update_existing_assets_if_not_overwriting
    assert !FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
    @plugin.update_assets(false)
    assert !FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
  end
  
  def test_should_update_existing_assets_if_overwriting
    assert !FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
    @plugin.update_assets(true)
    assert FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
  end
  
  def test_copy_should_overwrite_existing_files
    assert !FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
    @plugin.copy_assets
    assert FileUtils.identical?(@blank_file, "#{@path}/assets/images/blank.gif")
    
    expected = [
      'images',
      'images/blank.gif',
      'images/dot.gif',
      'stylesheets'
    ].collect! {|path| "#{@public_root}/#{path}"}
    assert_equal expected, current_public_files
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginAssetsListTest < Test::Unit::TestCase
  def test_should_include_all_plugins
    expected = [
      ['calendar', [
          "#{source_assets_path(:calendar)}/javascripts",
          "#{source_assets_path(:calendar)}/javascripts/jscalendar",
          "#{source_assets_path(:calendar)}/javascripts/jscalendar/core.js",
          "#{source_assets_path(:calendar)}/stylesheets",
          "#{source_assets_path(:calendar)}/stylesheets/jscalendar.css"
        ]
      ],
      ['gallery', [
          "#{source_assets_path(:gallery)}/images",
          "#{source_assets_path(:gallery)}/images/blank.gif",
          "#{source_assets_path(:gallery)}/images/dot.gif"
        ]
      ],
      ['graphing', [
          "#{source_assets_path(:graphing)}/images",
          "#{source_assets_path(:graphing)}/images/dot.gif",
          "#{source_assets_path(:graphing)}/stylesheets",
          "#{source_assets_path(:graphing)}/stylesheets/graphs.css"
        ]
      ],
      ['plugin_with_empty_asset_folders', [
          "#{source_assets_path(:plugin_with_empty_asset_folders)}/javascripts"
        ]
      ]
    ]
    assert_equal expected, PluginAWeek::PluginsPlus::Assets.list
  end
  
  def test_should_include_specific_plugins_if_specified
    expected = [
      ['gallery', [
          "#{source_assets_path(:gallery)}/images",
          "#{source_assets_path(:gallery)}/images/blank.gif",
          "#{source_assets_path(:gallery)}/images/dot.gif"
        ]
      ],
      ['graphing', [
          "#{source_assets_path(:graphing)}/images",
          "#{source_assets_path(:graphing)}/images/dot.gif",
          "#{source_assets_path(:graphing)}/stylesheets",
          "#{source_assets_path(:graphing)}/stylesheets/graphs.css"
        ]
      ]
    ]
    assert_equal expected, PluginAWeek::PluginsPlus::Assets.list('gallery,graphing')
  end
end

class PluginAssetsCopyTest < Test::Unit::TestCase
  def setup
    setup_public_assets
  end
  
  def test_should_update_and_overwrite_all_plugin_assets
    PluginAWeek::PluginsPlus::Assets.copy
    
    expected = [
      "#{@public_root}/images",
      "#{@public_root}/images/blank.gif",
      "#{@public_root}/images/dot.gif",
      "#{@public_root}/javascripts",
      "#{@public_root}/javascripts/jscalendar",
      "#{@public_root}/javascripts/jscalendar/core.js",
      "#{@public_root}/stylesheets",
      "#{@public_root}/stylesheets/graphs.css",
      "#{@public_root}/stylesheets/jscalendar.css"
    ]
    assert_equal expected, current_public_files
    assert FileUtils.identical?(@blank_file, "#{source_assets_path(:gallery)}/images/blank.gif")
  end
  
  def test_should_update_and_overwrite_specific_plugin_assets_if_specified
    PluginAWeek::PluginsPlus::Assets.copy('gallery,graphing')
    
    expected = [
      "#{@public_root}/images",
      "#{@public_root}/images/blank.gif",
      "#{@public_root}/images/dot.gif",
      "#{@public_root}/stylesheets",
      "#{@public_root}/stylesheets/graphs.css"
    ]
    assert_equal expected, current_public_files
    assert FileUtils.identical?(@blank_file, "#{source_assets_path(:gallery)}/images/blank.gif")
  end
  
  def teardown
    teardown_public_assets
  end
end

class PluginAssetsUpdateTest < Test::Unit::TestCase
  def setup
    setup_public_assets
  end
  
  def test_should_only_update_plugin_assets_which_dont_exist
    PluginAWeek::PluginsPlus::Assets.update
    
    expected = [
      "#{@public_root}/images",
      "#{@public_root}/images/blank.gif",
      "#{@public_root}/images/dot.gif",
      "#{@public_root}/javascripts",
      "#{@public_root}/javascripts/jscalendar",
      "#{@public_root}/javascripts/jscalendar/core.js",
      "#{@public_root}/stylesheets",
      "#{@public_root}/stylesheets/graphs.css",
      "#{@public_root}/stylesheets/jscalendar.css"
    ]
    assert_equal expected, current_public_files
    assert !FileUtils.identical?(@blank_file, "#{source_assets_path(:gallery)}/images/blank.gif")
  end
  
  def test_should_only_update_specific_plugin_assets_which_dont_exist_if_specified
    PluginAWeek::PluginsPlus::Assets.update('gallery,graphing')
    
    expected = [
      "#{@public_root}/images",
      "#{@public_root}/images/blank.gif",
      "#{@public_root}/images/dot.gif",
      "#{@public_root}/stylesheets",
      "#{@public_root}/stylesheets/graphs.css"
    ]
    assert_equal expected, current_public_files
    assert !FileUtils.identical?(@blank_file, "#{source_assets_path(:gallery)}/images/blank.gif")
  end
  
  def teardown
    teardown_public_assets
  end
end
end
