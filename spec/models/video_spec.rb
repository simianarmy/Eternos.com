# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Video do
  include ContentSpecHelper
  
  before(:each) do
    @video = new_content(:type => :video)
  end
  
  it "should not be valid without required attributes" do
    @video.should be_valid
    @video.title = nil
    @video.should_not be_valid
  end
  
  it "should be a video type" do
     @video.stubs(:transcode).returns(true)
     @video.type.should == "Video"
   end
end

describe Video, "on create" do
  include ContentSpecHelper
  
  before(:each) do
    @video = new_content(:type => :video)
  end
  
  it "should create object" do
    lambda {
      @video.save
    }.should change(Content, :count).by(1)
  end
  
  it "should collect file metadata after file saved" do
    @video.expects(:save_metadata).once
    @video.save
  end
  
  it "should have a duration and bitrate after file saved" do
    @video.save
    @video.duration.should_not be_nil
  end
  
  it "should transcode if valid" do
    @video.expects(:transcode).once
    @video.save
  end
  
  it "should not save attachment" do
    @video.stubs(:transcode).returns(true)
    @video.save
    attachment_processed?(@video).should be_false
  end
end

describe Video, "on update" do
  include ContentSpecHelper
  
  before(:each) do
    @video = create_content(:type => :video)
  end
  
  it "should never process metadata" do
    @video.expects(:save_metadata).never
    @video.update_attributes(:taken_at => Time.now)
  end
  
  it "should not process video on validation" do
    @video.expects(:save_metadata).never
    @video.valid?
  end
end

  
