require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recording do
  include RecordingSpecHelper
  
  before(:each) do
    @recording = Recording.new
    @recording.stubs(:cleanup)
  end

  it "should not be valid without required attributes" do
    @recording.should_not be_valid
    @recording.stubs(:validate_on_create).returns(true)
    @recording.attributes = valid_recording_attributes
    @recording.should be_valid
  end
  
  it "full filename should be blank" do
    @recording.full_filename.should be_blank
  end
  
  it "should not be valid if file not found" do
    File.stubs(:exists?).returns(false)
    @recording.attributes = valid_recording_attributes
    @recording.should_not be_valid
  end
  
  it "should not be valid if file is empty" do
    File.stubs(:exists?).returns(true)
    File.stubs(:size?).returns(false)
    @recording.attributes = valid_recording_attributes
    @recording.should_not be_valid
  end
  
  it "should be valid with required attributes if file is valid" do
    @recording.attributes = valid_recording_attributes
    File.stubs(:exists?).returns(true)
    File.stubs(:size?).returns(true)
    @recording.should be_valid
  end
  
  it "should return audio type if audio recording" do
    @recording.filename = "audio111"
    @recording.should be_audio
  end
  
  it "should return video type if video recording" do
    @recording.filename = "video111"
    @recording.should be_video
  end
  
  it "should return nil type if unknown content type" do
    @recording.filename = "foo"
    @recording.should_not be_audio
    @recording.should_not be_video
  end
  
end

describe Recording, "on create" do
  include RecordingSpecHelper
  
  before(:each) do
    @recording = new_recording
    @recording.stubs(:validate_on_create).returns(true)
    @recording.stubs(:cleanup)
  end
  
  it "full filename should contain red5 flash streams directory" do
    @recording.stubs(:analyze).returns(true)
    @recording.save
    @recording.full_filename.should match(/#{AppConfig.FlashRecordingPath}/)
  end
  
  it "should be created" do
    lambda {
      @recording.stubs(:analyze).returns(true)
      @recording.save
    }.should change(Recording, :count).by(1)
  end
end

describe Recording, "state machine" do
  include RecordingSpecHelper
  
  before(:each) do
     @recording = new_recording
     @recording.stubs(:validate_on_create).returns(true)
     @recording.stubs(:analyze)
     @recording.stubs(:cleanup)
     @recording.save
  end
  
  it "should be in complete state when finished" do
    @recording.start_processing!
    @recording.finish_processing!
    @recording.should be_complete
  end
  
  it "should cleanup old files once processing is complete" do
    @recording.expects(:cleanup)
    @recording.start_processing!
    @recording.finish_processing!
  end
end

describe Recording, "with fixtures" do
  fixtures :all
  include RVideoInspectorSpecHelper
  
  before(:each) do
    @inspector = inspector
  end
  
  describe "audio recording" do
    include TranscoderSpecHelper
    
    before(:each) do
      @recording = create_recording(:type => :audio)
      @recording.stubs(:member).returns(mock_model(Member))
      @inspector.stubs(:content_type).returns('audio/mp3')
      @recording.stubs(:cleanup)
    end
    
    it "should be audio type" do
      @recording.should be_audio
    end
    
    describe "transcoding to mp3" do
      before(:each) do
        @transcoder = mock_transcoder(@recording)
      end

      it "should raise exception if conversion to mp3 fails" do
        @transcoder.expects(:flashToAudio).raises(RVideo::TranscoderError)
        lambda {
          @recording.to_mp3
        }.should raise_error(Recording::AudioConversionException)
      end
      
      it "should save transcoder commands" do
        @transcoder.expects(:flashToAudio)
        @recording.to_mp3
        @recording.command.should == @transcoder.command
        @recording.command_expanded == @transcoder.executed_commands
      end
      
      it "should create new tempfile to mp3 from the recording" do
        @transcoder.expects(:flashToAudio)
        @recording.to_mp3.should == @temp.path
      end
    
      describe "on successful transcoding" do
        before(:each) do
          @transcoder.expects(:flashToAudio)
        end
  
        it "should call audio object create from recording" do
          Audio.expects(:create_from_recording).with(:member=>@recording.member,
            :filename=>@temp.path, :inspector=>inspector,
            :parent_id => @recording.id).returns(@audio = mock('Audio'))
          @recording.save_content(@inspector).should be_eql(@audio)
        end
      end
    end
    
    describe "with real inspector object of recorded audio" do
      it "should save inspector metadata to audio object" do
        lambda {
          real_inspector = RVideo::Inspector.new(:file => recorder_file)
          @recording.save_content(real_inspector)
        }.should_not raise_error
      end
    end
  end
  
  describe "video recording" do
    before(:each) do
      @recording = create_recording
      @recording.stubs(:full_filename).returns(fixture_path + @recording.filename)
      @recording.stubs(:cleanup)
    end
   
    it "should be a video type" do
      @recording.should be_video
    end

    it "should call web video object create from recording" do
      WebVideo.expects(:create_from_recording).with(:member=>@recording.member,
        :filename=>@recording.full_filename, :inspector=>@inspector,
        :parent_id => @recording.id).returns(mock('WebVideo'))
      @recording.save_content(@inspector)
    end
  end
end

