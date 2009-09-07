require 'rubygems'
require 'spork'


ENV["RUNNING_SPEC_SERVER"] = '1'
ENV["RAILS_ENV"] ||= 'test'
#require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require File.expand_path('../config/environment', File.dirname(__FILE__))
require 'spec/autorun'
require 'spec/rails'
require 'rspec_rails_mocha'
require 'fixjour'
require "tempfile"
require "test/unit"

require File.join(File.dirname(__FILE__), 'stub_chain_mocha')
require File.expand_path(File.dirname(__FILE__) + "/fixjour_builders.rb")
require File.expand_path(File.dirname(__FILE__) + "/content_spec_helper.rb")

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to ~/spec when you run 'ruby script/generate rspec'
  # from the project root directory.
  
  
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    Test::Unit::TestCase.fixture_path = config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

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
    # config.global_fixtures = :users
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
    # RSpec uses it's own mocking framework by default. If you prefer to
    # use mocha, flexmock or RR, uncomment the appropriate line:
    #
     config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    #
    # == Notes
    # 
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner
    config.before(:each) do
      full_example_description = "#{self.class.description} #{@method_name}"
      Rails::logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")
    end

    config.include(Fixjour) # This will add the builder methods to your ExampleGroups and not pollute Object
  end


  module Workling
    class Base
      class RailsBase
        def self.register; end
      end
    end
  end
  worker_path = File.dirname(__FILE__) + "/../app/workers"
  spec_files = Dir.entries(worker_path).select {|x| /\.rb\z/ =~ x}
  spec_files -= [ File.basename(__FILE__) ]
  spec_files.each { |path| require(File.join(worker_path, path)) }

  # Disable domain lookups
  EmailVeracity::Config[:lookup] = false
  

def set_mailer_in_test
  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.deliveries = []
end  

def reset_active_record_class(name)
  Object.send :remove_const, name if Object.const_defined?(name)
  Object.const_set(name, Class.new(ActiveRecord::Base))
end

module SaasSpecHelper
  def valid_address(attributes = {})
    {
      :first_name => 'John',
      :last_name => 'Doe',
      :address1 => '2010 Cherry Ct.',
      :city => 'Mobile',
      :state => 'AL',
      :zip => '36608',
      :country => 'US'
    }.merge(attributes)
  end

  def valid_card(attributes = {})
    { :first_name => 'Joe', 
      :last_name => 'Doe',
      :month => 2, 
      :year => Time.now.year + 1, 
      :number => '1', 
      :type => 'bogus', 
      :verification_value => '123' 
    }.merge(attributes)
  end

  def valid_user(attributes = {})
    { :login => 'foobar',
      :password => 'foobarass', 
      :password_confirmation => 'foobarass',
      :email => "bubba@hotmail.com",
      :first_name => "dr",
      :last_name => "no"
    }.merge(attributes)
  end
end

def skip_email_validation
  EmailVeracity::Address.stubs(:new).returns(@emv_addr=mock('EmailVeracity::Address'))
  @emv_addr.stubs(:valid?).returns(true)
end

#module LoginSpecHelper
  describe "a user is signed in", :shared => true do
    before( :each ) do
      @user = create_user
      @controller.stubs(:current_user).returns(@user)
    end
  end

  describe "a member is signed in", :shared => true do
    include UserSpecHelper
    before( :each ) do
      @user = @member = make_member
      @controller.stubs(:current_user).returns(@user)
    end
  end

  
  describe "a mocked member is signed in", :shared => true do
    include UserSpecHelper
    before( :each ) do
      @user = @member = mock_model(Member, :has_role_requirement? => true)
      @controller.stubs(:current_user).returns(@user)
    end
  end

  describe "an admin is signed in", :shared => true do
    before( :each ) do
      @user = @admin = create_user(:admin => true)
      @controller.stubs(:current_user).returns(@user)
    end
  end
#end

def response_to_json 
  ActiveSupport::JSON.decode(@response.body)
end

def time_period_attributes(start_t, end_t)
  {:time_period => {
    :beginning => date_select_attributes(start_t, "beginning"),
    :end => date_select_attributes(end_t, "end")
    }}
end

def date_select_attributes(t, attr)
  {"#{attr}(1i)"=>"#{t.year}", "#{attr}(2i)"=>"#{t.month}", "#{attr}(3i)"=>"#{t.day}", "#{attr}(4i)"=>"#{t.hour}", "#{attr}(5i)"=>"00"}
end

module UserSpecHelper
  
   # Work around Fixjour shit not adding passwords
  def valid_user_attributes_with_password
    returning valid_user_attributes do |a|
      a[:password] = a[:password_confirmation] = 'fuckthisshit'
    end
  end

  def make_member(attributes={})
    set_mailer_in_test
    user = create_user(attributes)
    user.activate!
    User.find(user)
  end
  
  def make_user_account_admin(user, account)
    user.is_admin_for account
  end
end

module GuestSpecHelper
  def new_guest_with_host(host=nil, options={})
    host ||= @member = create_member
    guest = new_guest(options)
    guest.current_host_id = host.id
    @circle = options[:circle] || create_circle
    guest.circle = @circle
    guest
  end
  
  def create_guest_with_host(host=nil, options={})
    guest = new_guest_with_host(host, options)
    guest.save!
    guest
  end
end

module AddressBookSpecHelper
  def valid_attributes
    name_attrs
  end
  
  def name_attrs
    {:first_name => 'dr', :last_name => 'jones'}
  end
  
  def phone_number_attrs
    {:area_code => '206', :number => '555-5555', 
      :phone_type=>PhoneNumber::PhoneTypes['Home']}
  end
  
  def create_address_attrs
    {:address_attributes => valid_address_attributes}
  end
  
  def create_new_phone_number_attrs
    {:new_phone_number_attributes => [phone_number_attrs]}
  end
  
  def create_empty_new_phone_number_attrs
    {:new_phone_number_attributes => [{:area_code => '', :number => '', 
      :phone_type=>PhoneNumber::PhoneTypes['Home']}]}
  end
  
  def create_existing_phone_number_attrs
    {:existing_phone_number_attributes => phone_number_attrs}
  end
  
  def create_user_details(user)
    @member_detail = create_address_book(:user => user)
  end
end

module ContentAuthorizationSpecHelper
  def all_public_attributes
    {:privacy_settings => {:authorization => ContentAuthorization::AuthPublic}}
  end
  
  def all_private_attributes
    {:privacy_settings => {:authorization => ContentAuthorization::AuthPrivate}}
  end
  
  def partial_privacy_attributes(guests=[], circles=[])
    {:privacy_settings => {:authorization => ContentAuthorization::AuthPartial,
    :guests => guests.collect {|g| g.id.to_s},
    :circles => circles.collect {|c| c.id.to_s}
  }}
  end
end

module StorySpecHelper
  def story_with_new_category
    h = valid_story_attributes.merge :new_category_name=>'new_category'
    h.delete :category_id
    h
  end
  
  def make_story(user, params)
    create_story({:member => user}.merge(params))
  end
end

module RecordingSpecHelper
  def valid_attributes
    {:filename => 'somefile.flv'}
  end
end

module RVideoInspectorSpecHelper
  def inspector
    @inspector = mock('RVideo::Inspector')
    @inspector.stubs(:audio_codec).returns('mpeg')
    @inspector.stubs(:duration).returns('100')
    @inspector.stubs(:fps).returns('100')
    @inspector.stubs(:bitrate).returns('64')
    @inspector.stubs(:bitrate_units).returns('kb/s')
    @inspector.stubs(:width).returns('300')
    @inspector.stubs(:height).returns('400')
    @inspector.stubs(:video_codec).returns('x-flv')
    @inspector
  end
end

module TranscoderSpecHelper
  def mock_transcoder(source)
    Paperclip::Tempfile.expects(:new).returns(@temp = mock('Tempfile'))
    @temp.stubs(:path).returns('/path/to/temp')
    Transcoder.expects(:new).with(source.full_filename, @temp.path).returns(@transcoder = mock('Transcoder'))
    @transcoder.stubs(:command).returns('ffmpeg')
    @transcoder.stubs(:executed_commands).returns('ffmeg exec')
    @transcoder
  end
  
  def flash_file
    fixture_path + 'flash_movie.flv'
  end

  def recorder_file
    fixture_path + 'recorder_audio.flv'
  end

  def tempfile(ext='.tmp')
    Tempfile.new("temp#{ext}").path
  end

  def build_transcoder(source, tmp=tempfile)
    Transcoder.new(source, @temp = tmp)
  end
end

class RenderLayout
  def initialize(expected)
    @expected = 'layouts/' + expected
  end

  def matches?(controller)
    @actual = controller.layout
    @actual == @expected
  end

  def failure_message
    return "render_layout expected #{@expected.inspect}, got #{@actual.inspect}", @expected, @acutual
  end

  def negative_failure_message
    return "render_layout expected #{@expected.inspect} not to equal #{@actual.inspect}", @expected, @actual
  end
end

def render_layout(expected)
  RenderLayout.new(expected)
end

module TimeLockSpecHelper
  def default_time_lock_attributes
    valid_time_lock_attributes.merge(:type => TimeLock.date_locked)
  end
  
  def default_death_lock_attributes
    valid_time_lock_attributes.merge(:type => TimeLock.death_locked)
  end
  
  def unlocked_time_lock_attributes
    {:type => TimeLock.unlocked}
  end
  
  def build_lock
    TimeLock.new(default_time_lock_attributes)
  end

  def new_time_locked_object
    new_story
  end
end

module FacebookerSpecHelper
  def new_facebooker_album
    Facebooker::Album.new(:aid => "100", :size=> 2, :link => 'link_url', :cover_pid => '10', 
      :name => 'test album', :modified => '1244850471', :aid => '100', :populated => true, 
      :location => 'nowwhere')
  end
  
  def new_facebooker_photo
    Facebooker::Photo.new(:aid => "100", :pid => rand(Time.now), 
      :caption => Faker::Lorem.sentence, :populated => true,
      :src_big => "http://#{Faker::Internet.domain_name}/pic.jpg", :tags => Faker::Lorem.words)
  end
end
    
module FacebookPhotoAlbumSpecHelper
  def new_album(album=new_facebooker_album)
    FacebookPhotoAlbum.new(album)
  end
  
  def new_photo(photo=new_facebooker_photo)
    FacebookPhoto.new(photo)
  end
end

module ActivityStreamProxySpecHelper
  def create_stream_proxy_item
    item = ActivityStreamProxy.new
    item.updated = item.created = Time.now.to_i
    item.message = 'blah blah'
    item.type = 'status'
    item.attachment = nil
    item
  end
  
  # Only facebook supported right now
  def create_stream_proxy_item_with_attachment(type)
    item = ActivityStreamProxy.new
    item.updated = item.created = Time.now.to_i
    item.message = 'blah blah'
    item.attachment_type = type
    item.type = 'post'
    item
  end
  
  def create_facebook_stream_proxy_item_with_attachment(type)
    item = create_stream_proxy_item_with_attachment(type)
    # From live data
    case type
    when 'photo'
      item.attachment = "--- \nhref: http://www.facebook.com/photo.php?pid=30278880&amp;id=1241462621\nphoto: \n  pid: \"5332041356431721696\"\n  aid: \"5332041356403459399\"\n  index: \"1\"\n  height: \"434\"\n  owner: \"1241462621\"\n  width: \"604\"\ntype: photo\nsrc: http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs126.snc1/5409_1109259931986_1241462621_30278880_7526228_s.jpg\nalt: {}\n\n"
    when 'video'
      item.attachment = "--- \nhref: http://www.facebook.com/ext/share.php?sid=118488009263&amp;h=Uk_ht&amp;u=e8Tgi\ntype: video\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=98ddec74796e916446bbe3468c840250&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FxgHmSdpjEIk%2F2.jpg&amp;w=130&amp;h=130\nalt: Thousand-Hand Guan Yin\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=118488009263#s118488009263\n  source_url: http://www.youtube.com/v/xgHmSdpjEIk&amp;autoplay=1\n  display_url: http://www.youtube.com/watch?v=xgHmSdpjEIk&amp;eurl=http://www.facebook.com/home.php?ref=home&amp;feature=player_embedded#t=124\n  owner: \"504883639\"\n  source_type: html\n"
    when 'generic'
      item.attachment = "--- \nname: \"Is the SexTracker Creator a Monster? \\xC2\\xAB The Gonzo Fat Savage Lifestyle\"\nhref: http://www.facebook.com/ext/share.php?sid=128131996883&amp;h=iNgGX&amp;u=kmFJK\nfb_object_type: {}\n\nfb_object_id: {}\n\nicon: http://static.ak.fbcdn.net/rsrc.php/zADLZ/hash/ezwlslya.gif\nmedia: {}\n\ncaption: \"Source: fatsavage.wordpress.com\"\ndescription: \"It\\xE2\\x80\\x99s kind of hard to figure out if Andrew Edmond is a creep, cop, criminal or con-man. I mean I\\xE2\\x80\\x99ve never met the man and he never sent me a copy of his resume so I have to develop his profile from online information. ...\"\nproperties: {}\n\n"
    when 'friendfeed'
      item.attachment_type = 'generic'
      item.attachment = "--- \nhref: http://www.facebook.com/\nfb_object_type: {}\n\nfb_object_id: {}\n\nicon: http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v43/209/2795223269/app_2_2795223269_1202.gif\nmedia: {}\n\ndescription: \"&lt;div class=&quot;CopyTitle&quot;&gt;Marc posted &lt;a rel=&quot;nofollow&quot; href=&quot;http://www.amazon.com/dp/0887307280/&quot; onclick=&quot;(new Image()).src = &amp;#039;/ajax/ct.php?app_id=2795223269&amp;amp;action_type=3&amp;amp;post_form_id=6657946eb0d4e5ad7a77b966f4e0a040&amp;amp;position=14&amp;amp;&amp;#039; + Math.random();return true;&quot;&gt;The E-Myth Revisited: Why Most Small Businesses Don't Work and What to Do About It&lt;/a&gt; via &lt;a href=&quot;http://apps.facebook.com/friendfeed/&quot; onclick=&quot;(new Image()).src = &amp;#039;/ajax/ct.php?app_id=2795223269&amp;amp;action_type=3&amp;amp;post_form_id=6657946eb0d4e5ad7a77b966f4e0a040&amp;amp;position=14&amp;amp;&amp;#039; + Math.random();return true;&quot;&gt;FriendFeed&lt;/a&gt;&lt;/div&gt;\"\nproperties: {}\n\n"
    when 'link'
      item.attachment = "--- \nhref: http://www.facebook.com/ext/share.php?sid=123275557061&amp;h=AS8HB&amp;u=zFAlt\ntype: link\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=bfbd14a77a70e85673eb9cd537214304&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3456%2F3829703647_8276334e5d_o.jpg&amp;w=130&amp;h=130\n"
    end
    item
  end
end

module EmailSpecHelper
  def raw_email
    IO.read ActionController::TestCase.fixture_path + 'raw_email.txt'
  end
end

module TimelineSearchSpecHelper
  def new_search(member, start_date, end_date, opts={})
    TimelineSearch.new(member.id, [start_date, end_date], opts)
  end
  
  def new_fake_search(member, start_date, end_date, opts={})
    TimelineSearchFaker.new(member.id, [start_date, end_date], opts)
  end
end

def with_transactional_fixtures(on_or_off)
  before(:all) do
    @previous_transaction_state = ActiveSupport::TestCase.use_transactional_fixtures
    ActiveSupport::TestCase.use_transactional_fixtures = on_or_off == :on
  end

  yield

  after(:all) do
    ActiveSupport::TestCase.use_transactional_fixtures = @previous_transaction_state
  end
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

