# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require "em-spec/rspec"

describe BackupJobPublisher do 
  include EM::SpecHelper
  
  describe "on run" do
    before(:each) do
    end
    
    # Something about the em call prevents MessageQueue from connecting so 
    # these tests should fail
    it "should connect to message queue" do
      MessageQueue.expects(:get_pending_backup_jobs_queue)
      lambda {
        BackupJobPublisher.run
      }.should_not raise_error
    end
    
    it "should process members that need backup" do
      MessageQueue.expects(:get_pending_backup_jobs_queue).returns(@queue = mock)
      Member.stub_chain(:needs_backup, :with_backup_targets).returns(
        [@member = mock('Member', :id => 1, :name => 'fooman')])
      @member.expects(:backup_in_progress!)
      BackupJobMessage.stub_chain(:new, :payload).with(@member).returns(@payload = mock)
      @queue.expects(:publish).with(@payload)
      
      lambda {
        BackupJobPublisher.run
      }.should_not raise_error
    end
  end
     
end