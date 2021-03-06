# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsWorker do
  def call_worker(id=1)
    UploadsWorker.new.upload_content_to_cloud(:id => id, :class => 'Content')
  end
  
  describe "mocking S3" do
    before(:each) do
      @content = mock('Content', :id => 1)
      @content.expects(:full_filename).at_least_once.returns('foo.doc')
      @content.expects(:public_filename).at_least_once.returns('/foo.doc')
      @content.expects(:content_type).at_least_once.returns('foo/foo')
      @content.expects(:start_cloud_upload!)
      Content.expects(:find).with(@content.id).returns(@content)
      S3Uploader.expects(:create).returns(@uploader = mock('S3Uploader'))
    end
  
    it "should upload a file to the cloud service and update container state" do 
      @uploader.expects(:upload).with(@content.full_filename, @content.public_filename, :content_type => @content.content_type)
      @uploader.expects(:key).returns('foo')
      @content.expects(:update_attribute).with(:s3_key, 'foo')
      @content.expects(:finish_cloud_upload!)
      call_worker
    end
  
    it "should put container object in error state if upload fails" do
      @content.expects(:cloud_upload_error)
      call_worker
    end
  end
  
  describe "S3 upload" do
    describe "on media upload" do
      before(:each) do
        @content = create_content(:type => :photo)
      end

      it "should save content S3 key" do
        @s3 = S3Uploader.instance
        call_worker(@content.id)
        @content.reload.s3_key.should_not be_nil
        @content.s3_key.should == S3Uploader.path_to_key(@content.public_filename)
      end
    end
  end
end
