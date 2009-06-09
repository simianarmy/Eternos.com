require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupJobMessage do
  describe "member without backup sources" do
    it "should create payload yaml from member with empty target sites" do
      @member = create_member
      payload = YAML.load(BackupJobMessage.new.payload(@member))
      payload[:user_id].should == @member.id
      payload[:target_sites].should be_empty
    end
  end
  
  describe "member with backup sources" do
    it "should create payload yaml from member with empty target sites" do
      @member = create_member
      @member.backup_sources << create_backup_source(:member => @member)
      payload = YAML.load(BackupJobMessage.new.payload(@member))
      payload[:target_sites].should have(1).item
      payload[:target_sites].first.should have(2).items
    end
  end
end