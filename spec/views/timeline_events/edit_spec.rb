require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/timeline_events/edit.html.haml" do
  include TimelineEventsHelper
  
  before do
    @timeline_event = mock_model(TimelineEvent)
    assigns[:timeline_event] = @timeline_event

    template.should_receive(:object_url).twice.and_return(timeline_event_path(@timeline_event)) 
    template.should_receive(:collection_url).and_return(timeline_events_path) 
  end

  it "should render edit form" do
    render "/timeline_events/edit.html.haml"
    
    response.should have_tag("form[action=#{timeline_event_path(@timeline_event)}][method=post]") do
    end
  end
end


