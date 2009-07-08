require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedEntry do
  describe "on new" do
    before(:each) do
      @entry = new_feed_entry
    end

    it "should create a new instance given valid attributes" do
      lambda {
        @entry.save
      }.should change(FeedEntry, :count).by(1)
    end
    
    it "should return a value for preview" do
      @entry.preview.should_not be_nil
    end
  end
end
