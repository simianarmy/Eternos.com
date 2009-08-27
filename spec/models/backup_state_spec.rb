# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupState do
  include UserSpecHelper

  def job_info
    {:job_id => 1, :errors => [], :messages => []}
  end

  describe "on save" do
    before(:each) do
      @bu_state = new_backup_state
    end

    it "should serialize the errors and messages arrays" do
      @bu_state.last_errors = %w( oh my god! )
      @bu_state.save!
      @bu_state.last_errors.should have(3).things
    end
  end

  describe "on finished!" do
    before(:each) do
      @bu_state = create_backup_state
      BackupJob.stubs(:find).returns(nil)
    end

    it "with new record should create object" do
      @bs = new_backup_state
      lambda {
        @bs.finished! job_info
      }.should change(BackupState, :count).by(1)
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
    
    it "should count saved items if count = 0" do
      @bu_state.expects(:has_data?)
      @bu_state.finished! job_info
    end
    
    it "should not count saved items once count > 0 saved" do
      @bu_state.items_saved = true
      @bu_state.expects(:has_data?).never
      @bu_state.finished! job_info
    end
    
    it "should not set data availability flag until 1st time data saved" do
      @bu_state.should_not be_first_time_data_available
      @bu_state.member.activity_stream.stubs(:items).returns([])
      @bu_state.finished! job_info
      @bu_state.should_not be_first_time_data_available
    end
    
    it "should set data availability flag on 1st time data saved" do
      @bu_state.should_not be_first_time_data_available
      @bu_state.member.activity_stream.stubs(:items).returns([1])
      @bu_state.finished! job_info
      @bu_state.should be_first_time_data_available
    end
  end
  
  describe "first_time_backup_data_available?" do
    before(:each) do
      @bu_state = create_backup_state
      BackupJob.stubs(:find).returns(nil)
    end
    
    it "should return data available status before 1st job saved" do
      @bu_state.should_not be_first_time_data_available
    end
    
    it "should not be true until has_data?" do
      @bu_state.finished! job_info
      @bu_state.first_time_data_available?.should be_false
      @bu_state.stubs(:has_data?).returns(true)
      @bu_state.finished! job_info
      @bu_state.first_time_data_available?.should be_true
    end
    
    it "should not be true more than once" do
      @bu_state.first_time_data_available?.should be_false
      @bu_state.stubs(:has_data?).returns(true)
      @bu_state.finished! job_info
      @bu_state.first_time_data_available?.should be_true
      @bu_state.finished! job_info
      @bu_state.reload.first_time_data_available?.should be_false
    end
  end
end
