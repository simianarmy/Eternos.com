# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupScheduler do
  describe "on run" do
    describe "without args" do
      it "should use calculated cutoff date" do
        Member.expects(:needs_backup).returns([@member = mock_model(Member)])
        @member.stub_chain(:backup_sources, :active).returns([@bs = mock_model(BackupSource)])
        BackupJobPublisher.expects(:run).with(@member, [@bs])
        BackupScheduler.new.run
      end
    end
    
    describe "with args" do
      it "should use cutoff option datetime arg in named_scope call" do
        date = Time.now
        Member.expects(:needs_backup).with(date).returns([])
        BackupScheduler.new.run(:cutoff => date)
      end
    end
  end
end