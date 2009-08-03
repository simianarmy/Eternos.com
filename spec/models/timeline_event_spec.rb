require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimelineEvent do
  before(:each) do
    @timeline_event = TimelineEvent.new
  end

  it "should be valid" do
    @timeline_event.should be_valid
  end
end
