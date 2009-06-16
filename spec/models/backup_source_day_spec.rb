# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupSourceDay do
  describe "on complete" do
    it "should return completed days" do
      BackupSourceDay.complete.should be_empty
      @bsd = create_backup_source_day
      BackupSourceDay.complete.should have(1).thing
      BackupSourceDay.complete.first.should be_eql(@bsd)
    end
  end
  
  describe "on failed" do
    it "should return failed backup days " do
      @bsd = create_backup_source_day
      BackupSourceDay.failed.should be_empty
      @bsd.status_id = 0
      @bsd.save
      BackupSourceDay.failed.should have(1).thing
      BackupSourceDay.failed.first.should be_eql(@bsd)
    end
    
    it "should not count failed but skipped days" do
      @bsd = create_backup_source_day(:status_id => 0, :skip => true)
      BackupSourceDay.failed.should be_empty
    end
  end
end
