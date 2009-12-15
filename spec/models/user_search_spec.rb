# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSearch do
  before(:all) do
    @user = create_member
  end
  
  describe "on create" do
    it "should require a user" do
      lambda {
        UserSearch.new
      }.should raise_error ArgumentError
    end
    
    it "should save user as attribute" do
      s = UserSearch.new(@user)
      s.user.should == @user
    end
  end
  
  describe "" do
    before(:each) do
      @search = UserSearch.new(@user)
      @search.user.stubs(:profile).returns(mock_model(Profile))
      @search.user.stubs(:activity_stream).returns(mock_model(ActivityStream))
      BackupSource.stubs(:blog).returns([:id => 1])
      BackupSource.stubs(:gmail).returns([:id => 1])
    end
    
    it "should return empty results before a search" do
      @search.results.should be_empty
    end
    
    describe "executing search" do
      before(:each) do
        @terms = 'foo foo'
      end
      
      it "should require search terms string arg" do
        lambda {
          @search.execute
        }.should raise_error ArgumentError
      end
      
      it "should search all indexed objects" do
        Content.expects(:by_user).with(@user.id).returns(@s = mock)
        @s.expects(:search).with(@terms).returns([])
        search_objects = [ ThinkingSphinx, ActivityStreamItem, FeedEntry, Feed, BackupEmail ]
        search_objects.each {|obj| obj.expects(:search).with(@terms, any_parameters).returns([])}
        @search.execute(@terms)
      end
    end
  end
end