# $Id$

require File.dirname(__FILE__) + '/../spec_helper'


describe BackupEmail do
  include EmailSpecHelper
  
  describe "named_scopes" do
    it "latest should respond array" do
      BackupEmail.latest.should be_a Array
    end
  end
  
  describe "on new" do
    before(:each) do
      @email = new_backup_email(:subject => 'subject', :sender => 'sender@email.com')
    end
    
    it "should not be valid without required attributes" do
      new_backup_email(:message_id => nil).should_not be_valid
      @email.should be_valid
    end
    
    it "should return temp filename" do
      @email.temp_filename.should match(/#{AppConfig.s3_staging_dir}/)
    end
    
    describe "on raw email assignment" do
      before(:each) do
        @email.email = raw_email
      end
      
      it "should populate attributes from raw email string" do  
        @email.subject.should == 'raw email subject'
        @email.sender.first.should == 'mail-noreply@google.com'
        @email.mailbox.should == 'inbox'
      end

      it "should write raw email to disk" do
        File.exist?(@email.temp_filename).should be_true
        IO.read(@email.temp_filename).should == raw_email
      end
    end
  end
  
  describe "on create" do
    before(:each) do
      @email = new_backup_email(:email => raw_email, :backup_source_id => 1)
    end
    
    it "should create object" do
      lambda {
        @email.save
      }.should change(BackupEmail, :count).by(1)
    end
    
    # Doesn't work in test env!
    it "should trigger after create callback" do
#      @email.expects(:after_commit_on_create)
#      @email.save
    end
  end
  
  describe "after save" do
    before(:each) do
      @email = create_backup_email(:backup_source_id => 1)
      @email.email = raw_email
      @email.after_commit_on_create # have to call manually??
      @email.reload
    end
    
    it "should return generate S3 key from attributes" do
      @email.s3_key.should == [@email.mailbox, @email.message_id, @email.backup_source_id].join(':')
    end
    
    it "should fetch raw email from s3" do
      @email.reload.raw.should == raw_email
    end
    
    it "should parse body from raw email" do
      @email.body.should == TMail::Mail.parse(raw_email).body
    end
  end
  
  describe "on destroy" do
    before(:each) do
      @email = create_backup_email(:backup_source_id => 1)
      @email.email = raw_email
      @email.after_commit_on_create # have to call manually??
      @email.reload
      @s3 = S3Connection.new(:email)
    end
    
    it "should delete s3 first" do
      @s3.bucket.exists?(key = @email.s3_key).should be_true
      @email.destroy
      @s3.bucket.exists?(key).should be_false
    end
  end
end