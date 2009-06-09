require File.dirname(__FILE__) + '/../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/contents_spec_helper')

describe MusicController do
  fixtures :all
  integrate_views

  include ContentSpecHelper
  it_should_behave_like "a member is signed in"
  it_should_behave_like "a content child"
  
  before(:each) do
    @controller.class.protect_from_forgery :secret => "mysecret"
    @content = create_content(:type => :music, :owner => @member)
    @param_sym = :music
  end
 
end
