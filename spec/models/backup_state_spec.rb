# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupState do
  describe "on save" do
    before(:each) do
      @bu_state = BackupState.create(:user_id => 1)
    end
    
    it "should serialize the errors and messages arrays" do
      @bu_state.last_errors = %w( oh my god! )
      @bu_state.save!
      @bu_state.last_errors.should have(3).things
    end
    
    describe "on backup_finished!" do
      def job_info
        {:job_id => 1, :errors => [], :messages => []}
      end
      
      it "should save with data from basic hash argument" do
        @bu_state.finished!(job_info)
        @bu_state.last_backup_job_id.should == 1
        @bu_state.last_backup_finished_at.should be_close(Time.now, 1)
        @bu_state.last_successful_backup_at.should be_close(Time.now, 1)
        @bu_state.last_failed_backup_at.should be_nil
        @bu_state.last_messages.should == []
        @bu_state.last_errors.should be_nil
      end
      
      it "should save error fields if hash argument containts error messages" do
        @bu_state.finished!(job_info.merge(:errors => @errs = ["oh no!"]))
        @bu_state.last_successful_backup_at.should be_nil
        @bu_state.last_failed_backup_at.should be_close(Time.now, 1)
        @bu_state.last_errors.should === @errs
      end
      
      it "should save optional status messages" do
        @bu_state.finished!(job_info.merge(:messages => @messgs = ["oh yes!"]))
        @bu_state.last_successful_backup_at.should be_close(Time.now, 1)
        @bu_state.last_failed_backup_at.should be_nil
        @bu_state.last_messages.should === @messgs
      end
    end
  end
end