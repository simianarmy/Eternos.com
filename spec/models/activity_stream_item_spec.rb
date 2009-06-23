require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityStreamItem do
  include ActivityStreamProxySpecHelper
  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream_item
    }.should change(ActivityStreamItem, :count).by(1)
  end
  
  describe "" do
    before(:each) do
      @item = new_activity_stream_item
    end
  end
  
  describe "facebook item" do
    before(:each) do
      @item = new_facebook_activity_stream_item
      @proxy = create_stream_proxy_item
    end
    
    it "should have facebook type" do
      @item.should be_an_instance_of FacebookActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = FacebookActivityStreamItem.create_from_proxy @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
      @item.attachment_data.should be_nil
    end
    
    it "should store serialized attachment data" do
      @item = FacebookActivityStreamItem.create_from_proxy create_stream_proxy_item_with_attachment('photo')
      @item.activity_type.should == 'post'
      @item.attachment_type.should == 'photo'
      @item.attachment_data.should be_a Hash
      @item.attachment_data['photo'].should_not be_empty
    end
  end
end
