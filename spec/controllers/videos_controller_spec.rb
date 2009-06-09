# $Id$
require File.dirname(__FILE__) + '/../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/contents_spec_helper')

describe VideosController do
#  fixtures :all
  integrate_views

  include ContentSpecHelper
  it_should_behave_like "a member is signed in"
  it_should_behave_like "a content child"
  
  before(:each) do
    @controller.class.protect_from_forgery :secret => "mysecret"
    @content = create_content(:type => :video, :owner => @member)
    @param_sym = :video
  end
  
  it "update action should not start video transcoding process" do
    Video.stubs(:find).with(@content.id.to_s).returns(@content)
    @content.stubs(:update_attributes).returns(true)
    @content.expects(:transcode).never
    xhr :post, :update, :id => @content.id, :domId => 'poop', :video => {:title => 'ass'}
  end
  
end

