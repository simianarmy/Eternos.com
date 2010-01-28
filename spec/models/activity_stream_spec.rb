require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStream do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_member
    }.should change(ActivityStream, :count).by(1)
  end
  
  describe "initialized" do
    before(:each) do
      @stream = create_member.activity_stream
    end
   
    describe "adding items" do
      before(:each) do
        @items = [ActivityStreamItem.create_from_proxy!(@stream.id, create_stream_proxy_item)]
      end
      
      it "should add single item" do
        @stream.items << @items.first
        @stream.items.size.should == 1
      end
      
      it "should add multiple items at once" do
        ActivityStreamItem.create_from_proxy!(@stream.id, create_stream_proxy_item_with_attachment('photo'))
        @stream.items.size.should == 2
      end
      
      it "should save most recent activity time" do
        @stream.items << @items
        @stream.reload.last_activity_at.to_i.should be_close(@items.first.created_at, 2)
      end
      
      it "should allow mix of item sti types" do
        lambda {
          @item = FacebookActivityStreamItem.create_from_proxy!(@stream.id, create_stream_proxy_item)
          @stream.items << @item
        }.should change(@stream.items, :count).by(2)
      end
    end 
  end
end
