# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RUNNING_SPEC_SERVER"] = '1'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require "spec/mocks" 

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# For mislav's mock_model fix
#require File.expand_path(File.join(File.dirname(__FILE__), "support/rspec_rails_mocha.rb"))

### STUFF FROM OLDER spec_helpers
require 'spork'
require "email_spec/helpers"
require "email_spec/matchers"
require 'fixjour'
require "tempfile"
require "test/unit"
require 'thinking_sphinx/test'
ThinkingSphinx::Test.init

require File.join(File.dirname(__FILE__), 'stub_chain_mocha')
require File.expand_path(File.dirname(__FILE__) + "/fixjour_builders.rb")
require File.expand_path(File.dirname(__FILE__) + "/content_spec_helper.rb")

# for fixture_file_upload method
class ActiveSupport::TestCase
  include ActionController::TestProcess
end
### END STUFF FROM OLDER spec_helpers

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to ~/spec when you run 'ruby script/generate rspec'
  # from the project root directory.
  
  worker_path = File.dirname(__FILE__) + "/../app/workers"
  spec_files = Dir.entries(worker_path).select {|x| /\.rb\z/ =~ x}
  spec_files -= [ File.basename(__FILE__) ]
  spec_files.each { |path| require(File.join(worker_path, path)) }
  
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    ActiveSupport::TestCase.fixture_path = config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
 
    # == Fixtures
    #
    # You can declare fixtures for each example_group like this:
    #   describe "...." do
    #     fixtures :table_a, :table_b
    #
    # Alternatively, if you prefer to declare them only once, you can
    # do so right here. Just uncomment the next line and replace the fixture
    # names with your fixtures.
    #
    # config.global_fixtures = :table_a, :table_b
    #
    # If you declare global fixtures, be aware that they will be declared
    # for all of your examples, even those that don't use them.
    #
    # You can also declare which fixtures to use (for example fixtures for test/fixtures):
    #
    # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    #
    # == Mock Framework
    #
    # RSpec uses its own mocking framework by default. If you prefer to
    # use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    #
    # == Notes
    #
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner
   
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner
    config.before(:each) do
      full_example_description = "#{self.class.description} #{@method_name}"
      Rails::logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")
    end
  
    config.include(Fixjour) # This will add the builder methods to your ExampleGroups and not pollute Object
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
  end
end

Spork.each_run do
# This code will be run each time you run your specs.

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading 
#   code that you don't normally modify during development in the 
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#
end


