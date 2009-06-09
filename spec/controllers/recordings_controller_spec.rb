require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecordingsController do

  #Delete this example and add some real ones
  it "should use RecordingsController" do
    controller.should be_an_instance_of(RecordingsController)
  end
end

describe RecordingsController, "on new" do
  integrate_views
  it_should_behave_like "a member is signed in"

  it "should not render with layout" do
    get :new
    response.should_not render_layout('member')
  end
  
  # How to spec this?
  it "should render flashrecorder xml" do
    #controller.expects(:flashrecorder)
    #get :new
  end
end

describe RecordingsController, "flashrecorder xml" do
  integrate_views
  it_should_behave_like "a member is signed in"
  
  it "should set the redirect url to index if no known parent" do
    get :flashrecorder
    response.should render_template('flashrecorder')
    assigns[:redirect_on_save_url].should == recordings_path
  end
  
  it "should set the redirect url to new story if referrer is stories controller" do
    get :flashrecorder, :anywhere => 'stories'
    assigns[:redirect_on_save_url].should == new_story_url(:recording => 1)
  end
end

describe RecordingsController, "on create" do
  integrate_views
  it_should_behave_like "a member is signed in"
  
  before(:each) do
    Recording.stubs(:new).returns(@recording = mock_model(Recording))
  end

  describe "with valid attributes" do
    before(:each) do
      RecordingWorker.expects(:async_analyze).with(has_entry(:id => @recording.id))
      @recording.stubs(:save).returns(true)
    end
  
    it "should save recording id in session with default session key name" do
      post :create
      session[:last_recording].should == @recording.id
    end
    
    it "should save recording id in session with passed session key name" do
      post :create, :recording_id_session_key => 'test'
      session[:test].should == @recording.id
    end
  end
end

    
   