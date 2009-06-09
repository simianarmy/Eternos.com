# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe UploadsWorker do
  before(:each) do
    @content = mock('Content', :id => 1)
    @content.expects(:full_filename).at_least_once.returns('foo.doc')
    @content.expects(:public_filename).at_least_once.returns('/foo.doc')
    @content.expects(:content_type).at_least_once.returns('foo/foo')
    @content.expects(:start_cloud_upload!)
    Content.expects(:find).with(@content.id).returns(@content)
    S3Uploader.expects(:new).with(@content.full_filename, @content.public_filename, @content.content_type).returns(@uploader = mock('S3Uploader'))
  end
  
  it "should upload a file to the cloud service and update container state" do 
    @uploader.expects(:upload).returns(true)
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
  
  def call_worker
    # It would be better to mock a ContentPayload, but this causes weird 
    # singleton can't be dumped errors..
    UploadsWorker.async_upload_to_cloud(:id => 1)
  end
  
end
