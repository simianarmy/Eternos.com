require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../timeline_event_spec_helper')

module AudioSpecHelper
  
end

describe Audio do
  include ContentSpecHelper
   
  before(:each) do
    @audio = new_content(:type => :audio)
  end

  it "should not be valid without required attributes" do
    @audio.should be_valid
    @audio.title = nil
    @audio.should_not be_valid
  end
end

describe Audio, "on create" do
  include ContentSpecHelper
  include RVideoInspectorSpecHelper
  
  before(:each) do
    @audio = new_content(:type => :audio)
  end
  
  it "should create a music object" do
    @audio.save
    @audio.should be_an_instance_of Music
  end

  it "should not process audio" do
    @audio.save
    attachment_processed?(@audio).should be_false
  end
  
  it "should collect audio metadata after file saved" do
    @audio.expects(:save_metadata).once
    @audio.save
  end
  
  it "should have a duration and bitrate after file saved" do
    @audio.save
    @audio.duration.should_not be_nil
    @audio.bitrate.should_not be_nil
  end
  
  describe Audio, "from recording" do
    before(:each) do
      @recording = create_recording(:type => :audio)
      @inspector = inspector
      @inspector.stubs(:content_type).returns('audio/mpeg')
    end
    
    it "should create an object from valid source" do
      lambda {
        Audio.create_from_recording(:member => @recording.member,
          :filename=>fixture_path + @audio.filename, 
          :inspector => @inspector).should be_an_instance_of Audio
      }.should change(Audio, :count).by(1)
    end
  end
end

describe Audio do
  describe "" do
    before(:each) do
      @tl_event = create_content(:type => :audio)
    end
    it_should_behave_like "a timeline event"
  end
end

