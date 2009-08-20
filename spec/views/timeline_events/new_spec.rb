require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/timeline_events/new.html.haml" do
  include TimelineEventsHelper
  
  before(:each) do
    @timeline_event = mock_model(TimelineEvent)
    @timeline_event.stub!(:new_record?).and_return(true)
    assigns[:timeline_event] = @timeline_event


    template.stub!(:object_url).and_return(timeline_event_path(@timeline_event)) 
    template.stub!(:collection_url).and_return(timeline_events_path) 
  end

  it "should render new form" do
    render "/timeline_events/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", timeline_events_path) do
    end
  end
end


