# Load the plugin testing framework
$:.unshift("#{File.dirname(__FILE__)}/../../plugin_test_helper/lib")
require 'rubygems'
require 'plugin_test_helper'

# Create the Rails.root/public_bak/stylesheets directory (only necessary when this is a gem)
stylesheets_dir = "#{Rails.root}/public_bak/stylesheets"
FileUtils.mkdir(stylesheets_dir) unless File.directory?(stylesheets_dir)

class  Test::Unit::TestCase
  private
    # Asset helpers
    def setup_public_assets
      @public_root = "#{Rails.root}/public"
      FileUtils.cp_r("#{Rails.root}/public_bak", @public_root)
      @original_public_files = current_public_files
      @blank_file = "#{@public_root}/images/blank.gif"
    end
    
    def teardown_public_assets
      FileUtils.rm_rf(@public_root)
    end
    
    def plugin_path(plugin)
      "#{Rails.root}/vendor/plugins/#{plugin}"
    end
    
    def source_assets_path(plugin)
      "#{plugin_path(plugin)}/assets"
    end
    
    def current_public_files
      Dir["#{Rails.root}/public/**/*"].sort
    end
    
    # Migration helpers
    def setup_schema_information
      ActiveRecord::Base.connection.initialize_schema_migrations_table
    end
    
    def teardown_schema_information
      [Company, Employee, SchemaMigration, PluginSchemaInfo].each do |model|
        ActiveRecord::Base.connection.drop_table(model.table_name) if model.table_exists?
      end
    end
end
