# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe TranscodeWorker do
  fixtures :contents
  
  before(:each) do
    @raw_video = contents(:mp4_movie)
    Content.expects(:find).with(@raw_video.id).returns(@source = mock('Video'))
    @tv = Transcoding.create(:parent_id=>@raw_video.id)
    Transcoding.expects(:create).with(:parent_id=>@raw_video.id).returns(@tv)
  end
  
  it "should create a valid TranscodedVideo object" do
    @source.stubs(:full_filename).returns(good_movie_path)
    @tv.expects(:start_transcoding!)
    @tv.expects(:finish_transcoding!)
    call_worker 
  end
  
  it "should put container object in error state if transcode fails" do
    @source.stubs(:full_filename).returns(bad_movie_path)
    @tv.expects(:start_transcoding!)
    @tv.expects(:finish_transcoding!).never
    @tv.expects(:transcoding_error!)
    call_worker
  end
    
  def call_worker
    # It would be better to mock a ContentPayload, but this causes weird 
    # singleton can't be dumped errors..
    TranscodeWorker.async_transcode_video(:id => @raw_video.id)
  end
  
  def bad_movie_path
    "#{RAILS_ROOT}/spec/fixtures/small_movie.mov"
  end
  
  def good_movie_path
     "#{RAILS_ROOT}/spec/fixtures/large_movie.mpg"
  end
  
end
