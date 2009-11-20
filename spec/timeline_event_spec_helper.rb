# $Id$

module TimelineEventSpecHelper
end

describe "a timeline event", :shared => true do
  include TimelineEventSpecHelper
  
  it "should support to_json" do
    ActiveSupport::JSON.decode(@tl_event.to_json).should be_a Hash
  end
  
  it "should act_as_archivable" do
    @tl_event.should respond_to(:archivable_attribute)
  end
  
  it "should have start_date attributes" do
    @tl_event.should respond_to(:start_date)
    @tl_event.should respond_to(:end_date)
  end
  
  describe "on new TimelineEvent" do
    before(:each) do
      @event = TimelineEvent.new @tl_event
    end
    
    it "should have start & end attributes" do
      @event.start_date.should_not be_nil
      @event.should respond_to(:end_date)
    end
  end
end
