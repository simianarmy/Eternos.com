require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupJob do
  describe "on finish!" do
    before(:each) do
      @member = create_member
      @bj = create_backup_job(:member => @member)
    end
    
    it "should save associated user's backup status" do
      @info = {:total_bytes => 10}
      @bj.member.expects(:backup_finished!).with(@info)
      @bj.finish! @info
      @bj.size.should == 10
      @bj.finished_at.should be_close(Time.now, 1)
    end
    
    it "should save without a member association" do
      @bj.member = nil
      Member.expects(:backup_finished!).never
      @bj.finish!({})
    end
  end
end
