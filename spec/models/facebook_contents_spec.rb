# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookContent, "on new" do
  before(:each) do
    @profile = create_profile(:member => create_member)
    @fb = new_facebook_content(:profile => @profile)
  end

  it "should create a new instance given valid attributes" do
    @fb.should be_valid
    lambda {
      @fb.save
    }.should change(FacebookContent, :count).by(1)
  end
  
  it "should create facebook content at the same time attribute is saved" do
    fb = @profile.facebook_content || @profile.build_facebook_content
    fb.update_attribute(:friends, 'foo, fee')
    fb.profile.should be_eql(@profile)
    fb.reload.friends.should == 'foo, fee'
  end
end
