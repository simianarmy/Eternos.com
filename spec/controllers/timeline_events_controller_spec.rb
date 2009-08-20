require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimelineEventsController do
  describe "handling GET /timeline_events" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent)
      TimelineEvent.stub!(:find).and_return([@timeline_event])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all timeline_events" do
      TimelineEvent.should_receive(:find).with(:all).and_return([@timeline_event])
      do_get
    end
  
    it "should assign the found timeline_events for the view" do
      do_get
      assigns[:timeline_events].should == [@timeline_event]
    end
  end

  describe "handling GET /timeline_events/1" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent)
      TimelineEvent.stub!(:find).and_return(@timeline_event)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the timeline_event requested" do
      TimelineEvent.should_receive(:find).with("1").and_return(@timeline_event)
      do_get
    end
  
    it "should assign the found timeline_event for the view" do
      do_get
      assigns[:timeline_event].should equal(@timeline_event)
    end
  end

  describe "handling GET /timeline_events/new" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent)
      TimelineEvent.stub!(:new).and_return(@timeline_event)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new timeline_event" do
      TimelineEvent.should_receive(:new).and_return(@timeline_event)
      do_get
    end
  
    it "should not save the new timeline_event" do
      @timeline_event.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new timeline_event for the view" do
      do_get
      assigns[:timeline_event].should equal(@timeline_event)
    end
  end

  describe "handling GET /timeline_events/1/edit" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent)
      TimelineEvent.stub!(:find).and_return(@timeline_event)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the timeline_event requested" do
      TimelineEvent.should_receive(:find).and_return(@timeline_event)
      do_get
    end
  
    it "should assign the found TimelineEvents for the view" do
      do_get
      assigns[:timeline_event].should equal(@timeline_event)
    end
  end

  describe "handling POST /timeline_events" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent, :to_param => "1")
      TimelineEvent.stub!(:new).and_return(@timeline_event)
    end
    
    describe "with successful save" do
  
      def do_post
        @timeline_event.should_receive(:save).and_return(true)
        post :create, :timeline_event => {}
      end
  
      it "should create a new timeline_event" do
        TimelineEvent.should_receive(:new).with({}).and_return(@timeline_event)
        do_post
      end

      it "should redirect to the new timeline_event" do
        do_post
        response.should redirect_to(timeline_event_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @timeline_event.should_receive(:save).and_return(false)
        post :create, :timeline_event => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /timeline_events/1" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent, :to_param => "1")
      TimelineEvent.stub!(:find).and_return(@timeline_event)
    end
    
    describe "with successful update" do

      def do_put
        @timeline_event.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the timeline_event requested" do
        TimelineEvent.should_receive(:find).with("1").and_return(@timeline_event)
        do_put
      end

      it "should update the found timeline_event" do
        do_put
        assigns(:timeline_event).should equal(@timeline_event)
      end

      it "should assign the found timeline_event for the view" do
        do_put
        assigns(:timeline_event).should equal(@timeline_event)
      end

      it "should redirect to the timeline_event" do
        do_put
        response.should redirect_to(timeline_event_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @timeline_event.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /timeline_events/1" do

    before(:each) do
      @timeline_event = mock_model(TimelineEvent, :destroy => true)
      TimelineEvent.stub!(:find).and_return(@timeline_event)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the timeline_event requested" do
      TimelineEvent.should_receive(:find).with("1").and_return(@timeline_event)
      do_delete
    end
  
    it "should call destroy on the found timeline_event" do
      @timeline_event.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the timeline_events list" do
      do_delete
      response.should redirect_to(timeline_events_url)
    end
  end
end
