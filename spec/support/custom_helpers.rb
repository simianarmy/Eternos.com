# spec'ing workling from http://blog.zerosum.org/2008/10/4/testing-workling-with-rspec
module Workling
  class Base
    class RailsBase
      def self.register;  end
    end
  end
end

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

  def valid_subscription(attributes = {})
    { :plan => subscription_plans(:basic),
      :account => accounts(:localhost)
    }.merge(attributes)
  end
end

def skip_email_validation
EmailVeracity::Address.stubs(:new).returns(@emv_addr=mock('EmailVeracity::Address'))
@emv_addr.stubs(:valid?).returns(true)
end

def login_as(user)
@controller.stubs(:current_user).returns(user)
@controller.stubs(:current_user_session).returns(@session = mock_model(UserSession, :user => user))
end

#module LoginSpecHelper
describe "a user is signed in", :shared => true do
  before( :each ) do
    login_as @user = create_user
  end
end

describe "a member is signed in", :shared => true do
  include UserSpecHelper
  before( :each ) do
    login_as @user = @member = make_member
  end
end


describe "a mocked member is signed in", :shared => true do
  include UserSpecHelper
  before( :each ) do
    login_as @user = @member = mock_model(Member, :has_role_requirement? => true, :role => stub('Role'))
  end
end

describe "an admin is signed in", :shared => true do
  before( :each ) do
    login_as @user = @admin = create_user(:admin => true)
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
  def valid_user_attributes_with_password(attributes={})
    returning valid_user_attributes(attributes) do |a|
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

def create_address_book_address(user)
  user.address_book.update_attributes(create_address_attrs)
  user.address_book.addresses.last
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


module EmailSpecHelper
  def raw_email
    IO.read ActionController::TestCase.fixture_path + 'raw_email.txt'
  end

  def backup_email(opts={})
    opts.reverse_merge!(:backup_source => create_backup_source)
    email = new_backup_email(opts)
    email.email = raw_email
    email.save
    email
  end
end

module FeedHelper
  def stub_feed_info
    stub(:title => stub(:sanitize => 'title'),
    :url => 'url',
    :feed_url => 'feed_url',
    :etag => 'etag',
    :last_modified => Date.today,
    :entries => [mock]
    )
  end

  def make_feed(opts={})
    Feedzirra::Feed.stubs(:fetch_and_parse).returns(stub_feed_info)
    @feed = create_feed_url(opts)
  end

  def make_feed_entry(opts={})
    create_feed_entry(:feed => make_feed.feed)
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
