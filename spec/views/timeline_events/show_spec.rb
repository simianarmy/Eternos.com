require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/timeline_events/show.html.haml" do
  include TimelineEventsHelper
  
  before(:each) do
    @timeline_event = mock_model(TimelineEvent)

    assigns[:timeline_event] = @timeline_event

    template.stub!(:edit_object_url).and_return(edit_timeline_event_path(@timeline_event)) 
    template.stub!(:collection_url).and_return(timeline_events_path) 
  end

  it "should render attributes in <p>" do
    render "/timeline_events/show.html.haml"
  end
end

