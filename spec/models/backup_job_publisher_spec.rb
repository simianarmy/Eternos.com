# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require "moqueue"

describe BackupJobPublisher do 
  overload_amqp
  
  before(:each) do
    @member = mock_model(Member, :name => 'foo')
    @source = mock_model(BackupSource, :backup_site => stub(:type_name => 'foo'))
    MessageQueue.stubs(:pending_backup_jobs_queue).returns(@mq = MQ.new.queue("backup"))
  end
  
  describe BackupJobPublisher::BackupJobMessage do
    before(:each) do
      @msg = BackupJobPublisher::BackupJobMessage.new
    end
    
    it "should convert single backup source to yaml object" do
      payload = YAML.load(@msg.member_payload(@member, @source))
      payload[:user_id].should > 0
      payload[:target_sites].should have(1).item
    end
    
    it "should convert multiple backup sources to yaml object" do
      payload = YAML.load(@msg.member_payload(@member, @source, @source))
      payload[:user_id].should > 0
      payload[:target_sites].should have(2).items
    end
  end
  
  describe "on run" do 
    before(:each) do
      MessageQueue.stubs(:pending_backup_jobs_queue).returns(@mq = MQ.new.queue("backup"))
      BackupJobPublisher::BackupJobMessage.expects(:new).returns(@bj_message = mock('BackupJobMessage'))
    end
    
    it "should update member backup state and publish backup jobs to queue" do  
      @mq.subscribe {|msg| "got a msg #{msg}" }
      @member.expects(:backup_in_progress!)
      @bj_message.expects(:member_payload).with(@member, @source).returns(@payload = mock)
      BackupJobPublisher.run(@member, @source)
      @mq.received_message?(@payload).should be_true
    end
    
    it "should handle multiple sources for one member" do
      @bj_message.expects(:member_payload).with(@member, *[@source, @source])
      @member.stubs(:backup_in_progress!)
      BackupJobPublisher.run(@member, [@source, @source])
    end
  end
  
  describe "on add_source" do
    before(:each) do
      BackupJobPublisher::BackupJobMessage.expects(:new).returns(@bj_message = mock('BackupJobMessage'))
      @source.stubs(:member).returns(@member)
    end
    
    it "should create payload from single source" do
      @bj_message.expects(:member_payload).with(@member, @source)
      BackupJobPublisher.add_source(@source)
    end
    
    it "should send backup job for single backup source" do
      @bj_message.stubs(:member_payload).returns(@payload = mock)
      BackupJobPublisher.add_source(@source)
      @mq.received_message?(@payload).should be_true
    end
  end
end