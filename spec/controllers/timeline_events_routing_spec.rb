require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimelineEventsController do
  describe "route generation" do

    it "should map { :controller => 'timeline_events', :action => 'index' } to /timeline_events" do
      route_for(:controller => "timeline_events", :action => "index").should == "/timeline_events"
    end
  
    it "should map { :controller => 'timeline_events', :action => 'new' } to /timeline_events/new" do
      route_for(:controller => "timeline_events", :action => "new").should == "/timeline_events/new"
    end
  
    it "should map { :controller => 'timeline_events', :action => 'show', :id => 1 } to /timeline_events/1" do
      route_for(:controller => "timeline_events", :action => "show", :id => 1).should == "/timeline_events/1"
    end
  
    it "should map { :controller => 'timeline_events', :action => 'edit', :id => 1 } to /timeline_events/1/edit" do
      route_for(:controller => "timeline_events", :action => "edit", :id => 1).should == "/timeline_events/1/edit"
    end
  
    it "should map { :controller => 'timeline_events', :action => 'update', :id => 1} to /timeline_events/1" do
      route_for(:controller => "timeline_events", :action => "update", :id => 1).should == "/timeline_events/1"
    end
  
    it "should map { :controller => 'timeline_events', :action => 'destroy', :id => 1} to /timeline_events/1" do
      route_for(:controller => "timeline_events", :action => "destroy", :id => 1).should == "/timeline_events/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'timeline_events', action => 'index' } from GET /timeline_events" do
      params_from(:get, "/timeline_events").should == {:controller => "timeline_events", :action => "index"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'new' } from GET /timeline_events/new" do
      params_from(:get, "/timeline_events/new").should == {:controller => "timeline_events", :action => "new"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'create' } from POST /timeline_events" do
      params_from(:post, "/timeline_events").should == {:controller => "timeline_events", :action => "create"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'show', id => '1' } from GET /timeline_events/1" do
      params_from(:get, "/timeline_events/1").should == {:controller => "timeline_events", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'edit', id => '1' } from GET /timeline_events/1;edit" do
      params_from(:get, "/timeline_events/1/edit").should == {:controller => "timeline_events", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'update', id => '1' } from PUT /timeline_events/1" do
      params_from(:put, "/timeline_events/1").should == {:controller => "timeline_events", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'timeline_events', action => 'destroy', id => '1' } from DELETE /timeline_events/1" do
      params_from(:delete, "/timeline_events/1").should == {:controller => "timeline_events", :action => "destroy", :id => "1"}
    end
  end
end
