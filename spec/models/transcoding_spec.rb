# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transcoding do
  before(:each) do
    @transcoding = Transcoding.new
  end

  it "should not be valid without parent id" do
    @transcoding.should_not be_valid
    @transcoding.parent_id = 1
    @transcoding.should be_valid
  end
end

describe Transcoding, "after successful transcode" do
  fixtures :transcodings
  
  before(:each) do 
    @transcoding = transcodings(:raw_mp4)
  end
  
  it "should create a new webvideo object" do
    WebVideo.expects(:create_from_transcoding).with(@transcoding)
    @transcoding.start_transcoding!
    @transcoding.finish_transcoding!
  end
  
  it "new web video object should match transcoding values" do
    WebVideo.find_by_parent_id(@transcoding.parent_id).should be_nil
    @transcoding.start_transcoding!
    @transcoding.finish_transcoding!
    wv = WebVideo.find_by_parent_id(@transcoding.parent_id)
    wv.should be_valid
  end
end
