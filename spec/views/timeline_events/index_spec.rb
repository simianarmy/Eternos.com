require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/timeline_events/index.html.haml" do
  include TimelineEventsHelper
  
  before(:each) do
    timeline_event_98 = mock_model(TimelineEvent)
    timeline_event_99 = mock_model(TimelineEvent)

    assigns[:timeline_events] = [timeline_event_98, timeline_event_99]

    template.stub!(:object_url).and_return(timeline_event_path(@timeline_event)) 
    template.stub!(:new_object_url).and_return(new_timeline_event_path) 
    template.stub!(:edit_object_url).and_return(edit_timeline_event_path(@timeline_event)) 
  end

  it "should render list of timeline_events" do
    render "/timeline_events/index.html.haml"
  end
end

