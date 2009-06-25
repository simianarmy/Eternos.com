# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookContent, "on new" do
  def friends
    ['john', 'sarah']
  end
  
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
    fb.update_attribute(:friends, friends)
    fb.profile.should be_eql(@profile)
    fb.profile.facebook_content.should_not be_nil
  end
  
  it "should serialize friends to/from array on save/read" do
    @fb.update_attribute(:friends, friends)
    @fb.friends.should be_a Array
    @fb.friends.should be_eql(friends)
  end
  
  it "should serialize groups to/from array on save/read" do
    @fb.update_attribute(:groups, friends)
    @fb.groups.should be_a Array
    @fb.groups.should be_eql(friends)
  end
end
