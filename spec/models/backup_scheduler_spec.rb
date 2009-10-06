# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require "moqueue"

describe BackupScheduler do
  overload_amqp

  describe "on run" do
    before(:each) do
      MessageQueue.stubs(:execute).with(&@block).yields(&@block)
      @member = mock_model(Member)
      @member.stub_chain(:backup_sources, :active).returns([@bs = mock_model(BackupSource)])
      Member.stubs(:needs_backup).returns([@member])
    end

    describe "without args" do
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
      end
      
      it "should use cutoff option datetime arg in named_scope call" do
        Member.expects(:needs_backup).with(@date).returns([@member])
        BackupScheduler.stubs(:source_scheduled_for_backup?).returns(false)
        BackupScheduler.run(:cutoff => @date)
      end
      
      it "should use cutoff date set by attribute writer" do
        Member.expects(:needs_backup).with(@date).returns([@member])
        BackupScheduler.stubs(:source_scheduled_for_backup?).returns(false)
        BackupScheduler.cutoff = @date
        BackupScheduler.run
      end
    end
    
    describe "has source who'se latest job has not finished" do
      it "should not publish new job" do
        BackupSourceJob.stub_chain(:backup_source_id_eq, :newest).returns(
          @bsj = mock_model(BackupSourceJob, :finished? => false)
          )
        BackupJobPublisher.expects(:run).never
        BackupScheduler.run
      end
    end

    describe "has source who'se latest job has finished" do
      before(:each) do
        BackupSourceJob.stub_chain(:backup_source_id_eq, :newest).returns(
          @bsj = mock_model(BackupSourceJob, :finished? => true)
          )
        @bsj.stubs(:inspect)
      end
      
      it "should publish new job if last job was not successful" do  
        @bsj.stubs(:successful?).returns(false)
        BackupJobPublisher.expects(:run).with(@member, [@bs])
        BackupScheduler.run
      end
      
      describe "when last job was successful" do
        before(:each) do
          @bsj.stubs(:successful?).returns(true)
        end
        
        it "should publish new job if it finished before the cutoff time" do
          @bsj.stubs(:finished_at).returns(1.year.ago)
          BackupJobPublisher.expects(:run).with(@member, [@bs])
          BackupScheduler.run
        end
        
        it "should not publish new job if it finished on or after the cutoff time" do
          @bsj.stubs(:finished_at).returns(BackupScheduler.cutoff_time)
          BackupJobPublisher.expects(:run).never
          BackupScheduler.run
        end
      end
    end
  end
end
