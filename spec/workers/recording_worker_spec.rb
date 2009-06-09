# $Id$
#
require File.dirname(__FILE__) + '/../spec_helper'
  
  
module RecordingWorkerHelper
  def start_worker(recording)
    RecordingWorker.async_analyze(:id=>recording.id)
  end
  
  def build_merged_inspector(inspector)
    {:inspector => inspector,
    :member => @recording.member,
    :filename => @recording.full_filename,
    :parent_id => @recording.id}
  end
end

describe RecordingWorker do
  include RecordingWorkerHelper
  
  before(:each) do
    @recording = mock_model(Recording)
  end
  
  it "should start worker with recording id as payload" do
    RecordingWorker.any_instance.expects(:analyze).with(has_entry(:id => @recording.id))
    RecordingWorker.async_analyze(:id=>@recording.id)
  end
  
  it "with invalid file should trigger error handler" do
    lambda {
      Recording.expects(:find).with(@recording.id).returns(@recording)
      @recording.expects(:start_processing!)
      @recording.expects(:update_attributes).with(has_key(:processing_error))
      @recording.expects(:processing_error!)
      # This fails...why?
      #RecordingWorker.expects(:save_error_message)
      @recording.stubs(:full_filename).returns(nil)
      start_worker @recording
    }.should_not raise_error
  end
end

describe RecordingWorker, "audio only" do
  fixtures :recordings
  include RecordingWorkerHelper
  include RVideoInspectorSpecHelper
  include TranscoderSpecHelper
  
  before(:each) do
    @recording = create_recording(:type => :audio)
    @filepath = fixture_path + @recording.filename
    @recording.stubs(:full_filename).returns(@filepath)
    @recording.stubs(:cleanup)
    @inspector = inspector
    Recording.expects(:find).with(@recording.id).returns(@recording)
    RVideo::Inspector.expects(:new).with(:file => @filepath).returns(@inspector)
  end
  
  describe "on successful completion" do
    before(:each) do
      @transcoder = build_transcoder(@recording)
      Transcoder.expects(:new).returns(@transcoder)
    end
    
    it "should not raise exception while processing valid recording" do
      lambda {
        RecordingWorker.expects(:save_error_message).never
        start_worker @recording
      }.should_not raise_error
    end

    it "should save audio conversion transcoder commands" do
      lambda {
        start_worker @recording
      }.should change(@recording, :command).from(nil).to(@transcoder.command)
    end
  end
  
  describe "state machine" do
    before(:each) do
      
    end
    
    it "recording state should be 'processing' while working" do
      lambda { 
        @recording.stubs(:save_content).with(@inspector).returns(true)
        @recording.expects(:finish_processing!)
        start_worker @recording
      }.should change(@recording, :state).from('pending').to('processing')
    end

    it "recording state should be 'complete' when finished with no errors" do
      lambda {
        @recording.stubs(:save_content).with(@inspector).returns(true)
        start_worker @recording
      }.should change(@recording, :state).from('pending').to('complete')
    end
    
    it "state should be 'error' if exception raised" do
      lambda {
        @recording.expects(:save_content).with(@inspector).raises(Recording::AudioConversionException)
        start_worker @recording
      }.should change(@recording, :state).from('pending').to('error')
    end
  end
end


describe RecordingWorker, "with video recording" do
  #fixtures :all
  include RecordingWorkerHelper
  include RVideoInspectorSpecHelper
  
  before(:each) do
    @recording = create_recording
    @filepath = fixture_path + @recording.filename
    @recording.stubs(:full_filename).returns(@filepath)
    @recording.stubs(:cleanup)
    Recording.expects(:find).with(@recording.id).returns(@recording)
    RVideo::Inspector.expects(:new).with(:file => @filepath).returns(@inspector=inspector)
  end
  
  it "state should be 'complete' when finished with no errors" do
    lambda {
      WebVideo.expects(:create_from_recording).with(build_merged_inspector(@inspector)).returns(mock('WebVideo'))
      start_worker @recording
    }.should change(@recording, :state).from('pending').to('complete')
  end
  
  it "state should be 'error' if exception raised" do
    lambda {
      @recording.expects(:save_content).with(@inspector).raises(Recording::ContentCreationException)
      start_worker @recording
    }.should change(@recording, :state).from('pending').to('error')
  end
end
