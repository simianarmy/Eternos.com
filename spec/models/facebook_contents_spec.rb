# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookContent do
  def friends
    ['john', 'sarah']
  end
  
  def validate_friends(content)
    content.friends.should be_a Array
    content.friends.should be_eql(friends)
  end
  
  before(:each) do
    @profile = create_profile(:member => @user = create_member)
  end
  
  describe "on create" do
    before(:each) do
      @fb = new_facebook_content(:profile => @profile)
    end
    
    it "should create a new instance given valid attributes" do
      @fb.should be_valid
      lambda {
        @fb.save
      }.should change(FacebookContent, :count).by(1)
    end
    
    it "should create facebook content at the same time attribute is saved" do
      lambda {
        @fb.update_attribute(:friends, friends)
      }.should change(FacebookContent, :count).by(1)
    end
    
    it "should save any serialize attributes" do
      @fb.friends = friends
      @fb.save
      validate_friends(@fb)
    end
    
    it "should have a single revision" do
      @fb.save
      @fb.revisions.should == [@fb]
    end
  end
  
  describe "on update" do
    before(:each) do
      @fb = create_facebook_content(:profile => @profile, 
        :friends => [], :groups => [])
    end
  
    it "should serialize friends to/from array on save/read" do
      @fb.update_attribute(:friends, friends)
      validate_friends(@fb)
    end
    
    describe "with auditing" do
      it "should create audit record of attribute changes" do
        FacebookContent.audit_as(@user) do
          @fb.update_attribute(:friends, friends)
        end
        validate_friends(@fb)
        @fb.revisions.size.should == 2
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should be_nil
        FacebookContent.audit_as(@user) do
          @fb.update_attribute(:friends, ['jack'])
        end
        @fb.revisions.size.should == 3
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should == friends
      end
      
      it "save_audited should wrap auditing functionality" do
        @fb.save_audited(:friends, @user, friends)
        validate_friends(@fb)
        @fb.revisions.size.should == 2
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should be_nil
        @fb.save_audited(:friends, @user, ['jack'])
        @fb.revisions.size.should == 3
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should == friends
      end
      
      it "should create audits when saved without wrapper" do
        @fb.update_attribute(:friends, friends)
        validate_friends(@fb)
        @fb.revisions.size.should == 2
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should be_nil
        @fb.update_attribute(:friends, ['jack'])
        @fb.revisions.size.should == 3
        @fb.revisions.last.should == @fb
        @fb.revision(:previous).friends.should == friends
      end
    end
  end
end
