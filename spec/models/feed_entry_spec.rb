require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedEntry do
  before(:all) do
    @feed = create_feed_url
  end
  
  describe "on new" do
    before(:each) do
      @entry = new_feed_entry(:feed => @feed.feed)
    end

    it "should create a new instance given valid attributes" do
      lambda {
        @entry.save
      }.should change(FeedEntry, :count).by(1)
    end
    
    it "should return a value for preview" do
      @entry.preview.should_not be_nil
    end
    
    it "should not raise error on screencap_url" do
      @entry.screencap_url.should be_nil
    end
  end
  
  describe "on create" do
    before(:each) do
      @entry = create_feed_entry(:feed => @feed.feed, 
        :url => 'http://simian187.vox.com/library/post/os-x-time-machine-problems.html')
    end
    
    it "should create feed_content association" do
      @entry.feed_content.should_not be_nil
    end
    
    it "should return empty string for url if no screencap" do
      @entry.screencap_url.should be_blank
      @entry.screencap_thumb_url.should be_blank
    end
  end
  
  describe "on destroy" do
    before(:each) do
      @entry = create_feed_entry(:feed => @feed.feed)
    end
    
    it "should be able to delete feed entry without errors" do
      lambda {
        @entry.destroy
      }.should_not raise_error
    end
    
    it "should soft-delete the entry" do
      @entry.destroy
      @entry.deleted_at.should_not be_nil
    end
  end
end
