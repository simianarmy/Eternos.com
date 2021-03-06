require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupSourceJob do
  before(:each) do
    @backup_source = create_backup_source
    @backup_job = create_backup_job(:member => @backup_source.member)
  end
  
  it "should create required valid associations" do
    @backup_source.should be_valid
    @backup_job.should be_valid
    @backup_source.member.should == @backup_job.member
  end
  
  describe "on create" do
    it "should create an object with valid attributes" do
      lambda {
        @backup_source.backup_source_jobs << BackupSourceJob.create(:backup_job => @backup_job)
      }.should change(BackupSourceJob, :count).by(1)
    end
    
    it "should not create an object without required attributes" do
      BackupSourceJob.new.save.should be_false
    end
    
    it "should create object with source & job id specified" do
      lambda {
        BackupSourceJob.create(:backup_source_id => @backup_source.id, :backup_job_id => 100)
      }.should change(BackupSourceJob, :count).by(1)
    end
    
    it "should raise exception if same source & job used to create record" do
      lambda {
        2.times {create_backup_source_job(:backup_source => @backup_source, :backup_job => @backup_job)}
      }.should raise_error
    end
    
    it "should return created jobs with association methods" do
      @job = create_backup_source_job(:backup_source => @backup_source, :backup_job => @backup_job)
      @backup_source.backup_source_jobs.first.should == @job
    end
  end
  
  describe "" do
    before(:each) do
      @job = create_backup_source_job(:backup_source => @backup_source, :backup_job => @backup_job)
    end

    describe "on finished!" do
      it "should update associated source's last backup time" do
        @job.finished!
        @job.finished_at.should == @job.backup_source.last_backup_at
      end
    end

    describe "on time_remaining" do
      before(:each) do
        @job.finished_at = nil
      end
      
      it "should return zero if it has finished" do
        @job.finished_at = Time.now
        @job.time_remaining.should == 0
      end

      it "should return non-zero value if it has not finished" do
        @job.time_remaining.should > 0
      end    
      
      it "should not be expired if it started < dataset interval ago" do
        ds = EternosBackup::SiteData.defaultDataSet
        @job.created_at = Time.now - (@job.time_to_expire(ds) - 60)
        @job.expired?(ds).should be_false
      end
      
      it "should be in expired state if it has not finished after the dataset interval" do
        ds = EternosBackup::SiteData.defaultDataSet
        @job.created_at = Time.now - (@job.time_to_expire(ds) + 60)
        @job.expired?(ds).should be_true
      end
    end
    
    describe "time_to_expire" do
      it "should not be zero" do
        @job.time_to_expire.should > 0
      end
      
      it "should not be zero for any dataset" do
        ds = EternosBackup::SiteData::FacebookOtherWallPosts
        @job.time_to_expire(ds).should == EternosBackup::DataSchedules.min_backup_interval(ds)
      end
    end
  end
end
