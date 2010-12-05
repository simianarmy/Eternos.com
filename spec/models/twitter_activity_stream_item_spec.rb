require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TwitterActivityStreamItem do
  include ActivityStreamProxySpecHelper

  
  it "should create a new instance given valid attributes" do
    lambda {
      create_activity_stream_item
    }.should change(ActivityStreamItem, :count).by(1)
  end
  
  before(:each) do
    @as = create_activity_stream
    Member.any_instance.stubs(:backup_sources).returns(stub(:facebook => [mock_model(BackupSource)]))
  end
  
  describe "twitter item" do
    before(:each) do
      @item = new_activity_stream_item :type => 'TwitterActivityStreamItem', :activity_stream => @as
      @proxy = create_stream_proxy_item
    end
    
    it "should have twitter type" do
      @item.should be_a TwitterActivityStreamItem
    end
    
    it "should create a new instance from a proxy object" do
      @item = TwitterActivityStreamItem.create_from_proxy! @as.id, @proxy
      @item.activity_type.should == 'status'
      @item.message.should == @proxy.message
    end
    
    it "should find with named scope" do
      @item.save
      ActivityStreamItem.twitter.find(@item.id).should == @item
    end
  end
end
