require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/eternos_backup')

describe EternosBackup::BackupJobPublisher::BackupJobMessage do
  before(:each) do
    @member = create_member
    @bs = create_backup_source(:member => @member)
  end
  
  describe "with valid args" do 
    it "should encode args into json object" do
      payload = ActiveSupport::JSON.decode(EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs).to_json)
      payload['user_id'].should == @member.id
      payload['target']['id'].should == @bs.id
      payload['target']['source'].should == @bs.backup_site.type_name
      payload['target']['options'].should be_empty
    end
    
    it "should create a unique job id" do
      payload1 = ActiveSupport::JSON.decode(EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs).to_json)
      payload1['job_id'].should_not be_blank
      payload2 = ActiveSupport::JSON.decode(EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs).to_json)
      payload2['job_id'].should_not == payload1['job_id']
    end
    
    it "should encode included options" do
      msg = EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs, {:one => "2"})
      payload = ActiveSupport::JSON.decode(msg.to_json)
      payload['target']['options']['one'].should == "2"
    end
    
    it "should return backup site name string" do
      msg = EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs)
      msg.site_name.should == @bs.backup_site.type_name
    end
    
    it "should return backup data type id if passed in options" do
      msg = EternosBackup::BackupJobPublisher::BackupJobMessage.new(@member, @bs, :dataType => 1)
      msg.data_type.should == 1
    end
  end
end