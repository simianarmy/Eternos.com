# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedUrl do
  describe "on new" do
    before(:each) do
      @feed = new_feed_url(:rss_url => '')
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
      @feed = new_feed_url
    end
    
    it "should fail with validation error if url is bad" do
      @feed.rss_url = 'http://asspony.com'
      @feed.save.should be_false
      @feed.errors.should have(1).error_on(:rss_url)
    end
    
    it "should create FeedUrl object" do
      lambda {
        @feed.save
      }.should change(FeedUrl, :count).by(1)
    end
    
    it "should only save the same feed url once" do
      lambda {
        create_feed_url
      }.should change(FeedUrl, :count).by(1)
    end
    
    it "should create Feed object" do
      @feed.feed.should be_nil
      @feed.save
      @feed.feed.should be_a Feed
      @feed.rss_url.should == @feed.feed.feed_url_s
    end
  end
end