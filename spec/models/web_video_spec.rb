# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module WebVideoSpecHelper
  def video_file_path
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/flash_movie.flv')
  end
end

describe WebVideo do
  include WebVideoSpecHelper
  
  before(:each) do
    @video = WebVideo.new
    @video.owner = create_member
    #@video.stubs(:after_attachment_saved).returns(true)
    @video.stubs(:create_thumbnails)
  end
  
  it "should take a temp file path and create a valid object" do
    @video.temp_path = File.new(video_file_path)
    @video.save
    @video.should be_valid
    File.exists?(@video.full_filename).should be_true
  end
  
  it "should upload to storage after saved" do
    @video.temp_path = File.new(video_file_path)
    @video.expects(:after_attachment_saved).once
    @video.save.should be_true
  end
end

describe WebVideo, "on create" do
  #fixtures :all
  include ContentSpecHelper
  include RVideoInspectorSpecHelper
  
  before(:each) do
    @video = new_content(:type => :web_video)
    @thumbnail_class = WebVideo.attachment_options[:thumbnail_class]
  end
  
  it "should not be valid without required attributes" do
    @video.should be_valid
    @video.title = nil
    @video.should_not be_valid
  end
  
  it "should create object" do
    lambda {
      @video.save
    }.should change(Content, :count).by(1)
  end
  
  it "should save metadata" do
    RVideo::Inspector.expects(:new).returns(@inspector=mock('RVideo::Inspector'))
    @video.expects(:save_metadata).with(@inspector).once
    @video.stubs(:create_thumbnails)
    @video.save.should be_true
  end
  
  it "should create thumbnail objects" do
    lambda {
      @video.save
    }.should change(@thumbnail_class, :count).by(WebVideo.attachment_options[:thumbnails].size)
  end
  
  it "should create thumbnail file with attributes" do
    @video.save
    @video.thumbnails(true).should_not be_empty
    @video.thumbnails.first.should be_an_instance_of @thumbnail_class
    File.exist?(@video.full_filename(:thumb)).should be_true
    @video.thumbnails.first.image_size.should =~ /^\d+x\d+/
  end
end

describe WebVideo, "on destroy" do
  #fixtures :all
  include ContentSpecHelper
  
  before(:each) do
    @video = create_content(:type => :web_video)
  end

  it "should destroy object" do
    lambda {
      @video.destroy
    }.should change(WebVideo, :count).by(-1)
  end
  
  it "should use custom destroy_thumbnails method" do
    @video.expects(:destroy_thumbnails)
    @video.destroy
  end
  
  it "should destroy thumbnails" do
    lambda {
      @video.destroy
    }.should change(WebVideo.attachment_options[:thumbnail_class], :count).by(
      -WebVideo.attachment_options[:thumbnails].size)
  end
  
  it "should destroy thumbnail files" do
    thumb_files = @video.thumbnails.collect(&:full_filename)
    @video.destroy
    thumb_files.map {|file| File.exist?(file).should be_false }
  end
end

describe WebVideo, "create from recording" do
  #fixtures :all
  include ContentSpecHelper
  include RVideoInspectorSpecHelper
  
  before(:each) do
    @recording = create_recording
    @inspector = inspector
  end
  
  it "should create WebVideo object" do
    lambda{
      WebVideo.create_from_recording(:member => @recording.member,
        :filename => fixture_path + @recording.filename,
        :inspector => @inspector).should be_an_instance_of WebVideo
    }.should change(WebVideo, :count).by(1)
  end
  
  describe "on success" do
    before(:each) do
      @video = WebVideo.create_from_recording(:member => @recording.member,
        :filename => fixture_path + @recording.filename,
        :inspector => @inspector)
    end
  
    it "should identify self as recording" do
      @video.should be_recording
    end
    
    it "should be found when querying contents for recordings" do
      @video.owner.contents.recordings.should include(@video)
    end
  end
end
