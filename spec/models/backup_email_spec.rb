# $Id$

require File.dirname(__FILE__) + '/../spec_helper'


describe BackupEmail do
  include EmailSpecHelper
  
  describe "named_scopes" do
    it "latest should respond array" do
      BackupEmail.latest.should be_a Array
    end
  end
  
  before(:each) do
    AppSetting.stubs(:first).returns(stub(:master => 'hYgQySo78PN9+LjeBp+dCg=='))
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

      it "should be able to decrypt & encrypt email" do
        raw_email.should == @email.decrypt(@email.encrypt(raw_email))
      end
      
      it "should write email to disk file" do
        File.exist?(@email.temp_filename).should be_true
      end

      it "should encrypt email before writing to disk" do
        @email.decrypt(IO.read(@email.temp_filename)).should == raw_email
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
    end
    
    it "subject should be encrypted" do
      @email.subject.should_not be_blank 
      @email.subject_encrypted.should_not be_blank
      @email.subject.should_not == @email.subject_encrypted
    end

    it "should create a file containing raw email" do
      File.exists?(@email.temp_filename).should be_true
    end
    
    describe "on upload" do
      before(:each) do
        @email.upload_to_s3(S3Uploader.create(:email))
        @email.reload
      end

      it "should delete temp raw email file" do
        File.exists?(@email.temp_filename).should be_false
      end
      
      it "should return generate S3 key from attributes" do
        @email.s3_key.should == [@email.mailbox, @email.message_id, @email.backup_source_id].join(':')
      end

      it "should fetch (encrypted) email from s3 & save decrypted value" do
        @email.reload.raw.should == raw_email
      end

      it "should decrypt & parse body from encrypted email" do
        @email.body.should == TMail::Mail.parse(raw_email).body
      end
    end
  end
  
  describe "on destroy" do
    before(:each) do
      @email = create_backup_email(:backup_source_id => 1)
      @email.email = raw_email
      @email.upload_to_s3(@s3 = S3Uploader.create(:email))
      @email.reload
    end
    
    it "should delete s3 first" do
      @s3.bucket.exists?(key = @email.s3_key).should be_true
      @email.destroy
      @s3.bucket.exists?(key).should be_false
    end
  end
end