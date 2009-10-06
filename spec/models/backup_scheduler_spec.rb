# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require "moqueue"

describe BackupScheduler do
  overload_amqp

  describe "on run" do
    before(:each) do
      MessageQueue.stubs(:execute).with(&@block).yields(&@block)
    end

    describe "without args" do
      before(:each) do
        Member.stubs(:needs_backup).returns([@member = mock_model(Member)])
      end

      describe "with sources to backup" do
        it "should send publish backup job for source" do
          @member.stub_chain(:backup_sources, :active).returns([@bs = mock_model(BackupSource)])
          BackupScheduler.stubs(:source_scheduled_for_backup?).returns(true)
          BackupJobPublisher.expects(:run).with(@member, [@bs])
          BackupScheduler.run
        end
      end

      describe "without sources to backup" do
        it "should not publish any jobs" do
          @member.stub_chain(:backup_sources, :active).returns([@bs = mock_model(BackupSource)])
          BackupScheduler.stubs(:source_scheduled_for_backup?).returns(false)
          BackupJobPublisher.expects(:run).never
          BackupScheduler.run
        end
      end
    end
    describe "with cutoff time arg" do
      before(:each) do
        @date = Time.now
        Member.expects(:needs_backup).with(@date).returns([@member = mock_model(Member)])
      end
      
      it "should use cutoff option datetime arg in named_scope call" do
        @member.stub_chain(:backup_sources, :active).returns([])
        BackupScheduler.run(:cutoff => @date)
      end
    end
  end
end
