# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

module BackupEmailSpecHelper
  
end

describe EmailsWorker do
  include EmailSpecHelper
  
  before(:each) do
    # This should be in helper module
    AppSetting.stubs(:first).returns(stub(:master => 'hYgQySo78PN9+LjeBp+dCg=='))
  end
  
  describe "on process_backup_email" do
    def call_worker(id=1)
      EmailsWorker.new.process_backup_email(:id => id)
    end
    
    before(:each) do
      @email = backup_email
    end
    
    it "should upload backup email to s3" do
      @email.should_not be_uploaded
      call_worker(@email.id)
      @email.reload.should be_uploaded
    end
  end
end

  
  