require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'timeline_search'

describe TimelineEvent do
  include TimelineSearchSpecHelper
    
  describe "on create" do
    describe "from an event object witout attachment" do
      before(:each) do
        @event = create_feed_entry
        @tl_event = TimelineEvent.new @event
      end
      
      it "should have type matching source object" do
        @tl_event.type.should == @event.to_str
      end
      
      it "should have start date attribute" do
        @tl_event.start_date.should_not be_nil
        @tl_event.start_date.should == @event.start_date
      end
      
      it "should not have an end date if source does not" do
        @event.try(:end_date).should be_nil
        @tl_event.end_date.should be_nil
      end
    end
    
    describe "from an event object with attachment" do
      include ActivityStreamProxySpecHelper
      before(:each) do
        @item = FacebookActivityStreamItem.create_from_proxy create_facebook_stream_proxy_item_with_attachment('photo')
        @tl_event = TimelineEvent.new @item
      end
      
      it "should have an attachment type attribute matching source object" do
        @tl_event.attachment_type.should == @item.attachment_type.downcase
      end
    end
  end
end
