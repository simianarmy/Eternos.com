# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedUrl do
  describe "on new" do
    before(:each) do
      @feed = FeedUrl.new
      @railscasts_url = 'http://feeds.feedburner.com/railscasts' 
    end
    
    it "should not be valid without required attributes" do
      @feed.should_not be_valid
      @feed.errors.should have(1).error_on(:rss_url) # validates_presence
    end
    
    it "should not be valid without valid feed url" do
      @feed.rss_url = 'bleargh'
      @feed.should_not be_valid
      @feed.errors.should have(1).error_on(:rss_url) # validate_feed
      @feed.rss_url = 'http://simian187.vox.com/library/posts/atom.xml'
      @feed.should be_valid
    end
    
    it "should set auth confirmation to true if valid feed" do
      lambda {
        @feed.rss_url = 'http://simian187.vox.com/library/posts/atom.xml'
        @feed.should be_valid
      }.should change(@feed, :confirmed?).from(false).to(true)
    end
  end
  
  describe "on create" do
    before(:each) do
      @feed = FeedUrl.new(:rss_url => 'http://feeds.feedburner.com/railscasts')
    end
    
    it "should create FeedUrl object" do
      lambda {
        @feed.save
      }.should change(FeedUrl, :count).by(1)
    end
    
    it "should only save the same feed url once" do
      lambda {
        FeedUrl.create(:rss_url => 'http://feeds.feedburner.com/railscasts')
      }.should change(FeedUrl, :count).by(1)
    end
  end
end