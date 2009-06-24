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
end
