require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStreamItem do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream_item
    }.should change(ActivityStreamItem, :count).by(1)
  end
  
  describe "facebook item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'FacebookActivityStreamItem'
      @proxy = create_stream_proxy_item
    end
    
    it "should have facebook type" do
      @item.should be_a FacebookActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = FacebookActivityStreamItem.create_from_proxy @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
      @item.attachment_data.should be_nil
    end
    
    describe "with attachment data" do
      before(:each) do
        @item = FacebookActivityStreamItem.create_from_proxy create_stream_proxy_item_with_attachment('photo')
      end

      it "should store serialized attachment data" do
        @item.activity_type.should == 'post'
        @item.attachment_type.should == 'photo'
        @item.attachment_data.should be_a Hash
        @item.attachment_data['photo'].should_not be_empty
      end

      it "should return the attachment data source url" do
        @item.url.should_not be_blank
      end
    end
      
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.facebook.find(@item.id).should == @item
    end
  end
  
  describe "twitter item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'TwitterActivityStreamItem'
      @proxy = create_stream_proxy_item
    end
    
    it "should have twitter type" do
      @item.should be_a TwitterActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = TwitterActivityStreamItem.create_from_proxy @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
    end
    
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.twitter.find(@item.id).should == @item
    end
  end
end
