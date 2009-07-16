require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupJobMessage do
  before(:each) do
    @member = create_member
  end
  
  describe "member without backup sources" do
    it "should create payload yaml from member with empty target sites" do
      payload = YAML.load(BackupJobMessage.new.member_payload(@member))
      payload[:user_id].should == @member.id
      payload[:target_sites].should be_empty
    end
  end
  
  describe "member with backup sources" do
    before(:each) do
      @member.backup_sources << create_backup_source(:member => @member)
    end
    
    it "should create payload yaml from member with empty target sites" do  
      payload = YAML.load(BackupJobMessage.new.member_payload(@member))
      payload[:target_sites].should have(1).item
      payload[:target_sites].first.should have(2).items
    end
    
    it "should create payload from backup source" do
      payload = YAML.load(BackupJobMessage.new.source_payload(@member.backup_sources.first))
      payload[:target_sites].should have(1).item
      payload[:target_sites][0][:id].should == @member.backup_sources.first.id
    end
  end
end