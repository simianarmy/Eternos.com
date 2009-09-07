# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe EmailsWorker do
  describe "on process_backup_email" do
    def call_worker(id=1)
      # It would be better to mock a ContentPayload, but this causes weird 
      # singleton can't be dumped errors..
      EmailsWorker.async_process_backup_email(:id => id)
    end
    
    before(:each) do
      @email = create_backup_email(:backup_source_id => 1)
    end
    
    it "should upload backup email to s3" do
      @email.should_not be_uploaded
      call_worker(@email.id)
      @email.should be_uploaded
    end
  end
end

  
  