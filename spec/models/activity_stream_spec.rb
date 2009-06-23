require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStream do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream
    }.should change(ActivityStream, :count).by(1)
  end
  
  describe "initialized" do
    before(:each) do
      @stream = create_activity_stream
    end

    it "should return nil for latest activity time" do
      @stream.latest_activity_time.should be_nil
    end
   
    describe "add_items" do
      before(:each) do
        @items = [create_stream_proxy_item]
      end
      it "should add single item" do
        @stream.add_items @items.first
        @stream.activity_stream_items.size.should == 1
      end
      
      it "should add multiple items at once" do
        @items << create_stream_proxy_item_with_attachment('photo')
        @stream.add_items @items
        @stream.activity_stream_items.size.should == 2
      end
      
      it "should return most recent activity timestamp" do
        @stream.add_items @items
        @stream.latest_activity_time.should == @items.first.created
      end
    end 
  end
end
