# $Id$

require File.dirname(__FILE__) + '/../spec_helper'


describe Transcoder do
  include TranscoderSpecHelper
  
  describe "create thumbnails" do
    before(:each) do
      @transcoder = build_transcoder(flash_file, tempfile('.jpg'))
    end
    
    it "should succeed with flash source" do
      lambda {
        @transcoder.createThumbnail
        File.size(@temp).should > 0
      }.should_not raise_error
    end
  
    it "should return list of raw commands" do
      @transcoder.createThumbnail
      @transcoder.executed_commands.should_not be_blank
    end
  
    it "should raise exception if input is not thumbnailable" do
      lambda {
        @transcoder.source = 'foo'
        @transcoder.createThumbnail
      }.should raise_error
    end
  
    it "should return processed object on success" do
      processed = @transcoder.createThumbnail
      processed.should_not be_unknown_format
    end
  end
  
  describe "convert flv to mp3" do
    describe "with valid input file" do
      before(:each) do
        @transcoder = build_transcoder(flash_file, tempfile('.mp3'))
      end
      
      it "should not raise exception" do
        lambda {
          @transcoder.flashToAudio
        }.should_not raise_error
      end
    
      it "should return a rvideo inspector object" do
        @transcoder.flashToAudio.should be_an_instance_of RVideo::Inspector
      end
      
      it "transcoder object should have command attributes" do
        @transcoder.flashToAudio
        @transcoder.command.should_not be_empty
        @transcoder.executed_commands.should_not be_empty
      end
      
      it "returned transcoder object should not have errors" do
        @transcoder.flashToAudio
        @transcoder.errors.should be_empty
      end
    end
    
    describe "with flash recorder audio file" do
      before(:each) do
        @transcoder = build_transcoder(recorder_file, tempfile('.mp3'))
      end
      
      it "should not raise exception" do
        lambda {
          @transcoder.flashToAudio
        }.should_not raise_error
      end
      
      it "returned inspector methods should raise exception" do
        lambda {
          inspector = @transcoder.flashToAudio
          inspector.fps
          inspector.width
          inspector.height
          inspector.duration.to_s
          inspector.respond_to?(:full_bitrate) ? 
            inspector.full_bitrate : inspector.bitrate.to_s
        }.should_not raise_error
      end
    end
  end
end