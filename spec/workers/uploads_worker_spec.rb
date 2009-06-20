# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsWorker do
  def call_worker(id=1)
    # It would be better to mock a ContentPayload, but this causes weird 
    # singleton can't be dumped errors..
    UploadsWorker.async_upload_to_cloud(:id => id)
  end
  
  describe "mocking S3" do
    before(:each) do
      @content = mock('Content', :id => 1)
      @content.expects(:full_filename).at_least_once.returns('foo.doc')
      @content.expects(:public_filename).at_least_once.returns('/foo.doc')
      @content.expects(:content_type).at_least_once.returns('foo/foo')
      @content.expects(:start_cloud_upload!)
      Content.expects(:find).with(@content.id).returns(@content)
      S3Uploader.expects(:new).returns(@uploader = mock('S3Uploader'))
    end
  
    it "should upload a file to the cloud service and update container state" do 
      @uploader.expects(:upload).with(@content.full_filename, @content.public_filename, @content.content_type)
      @uploader.expects(:url).returns('foo')
      @content.expects(:update_attributes).with(:cdn_url => 'foo')
      @content.expects(:finish_cloud_upload!)
      call_worker
    end
  
    it "should put container object in error state if upload fails" do
      @uploader.expects(:upload).raises(RuntimeError.new)
      @content.expects(:processing_error!).once
      @content.expects(:update_attributes).once
      call_worker
    end
  end
  
  describe "S3 upload" do
    before(:each) do
      @content = create_content(:photo)
    end
    
    it "should save content S3 url in object" do
      @s3 = S3Uploader.new
      call_worker(@content.id)
      @content.reload.url.should == @s3.url(@content.public_filename)
    end
  end
end
