# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

module EmailSpecHelper
  def raw_email
    IO.read ActionController::TestCase.fixture_path + 'raw_email.txt'
  end
end

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
    
    it "should populate attributes from raw email string" do
      @email.expects(:email_content=)
      @email.email = raw_email
      @email.subject.should == 'raw email subject'
      @email.sender.first.should == 'mail-noreply@google.com'
    end
  end
  
  describe "on create" do
    before(:each) do
      @email = new_backup_email
    end
    
    it "should create a BackupEmail object" do
      lambda {
        @email.save
      }.should change(BackupEmail, :count).by(1)
    end
    
    describe "with raw email" do
      before(:each) do
        @email.email = raw_email
      end
      
      it "should create an associated EmailContent object" do
        lambda {
          @email.save
        }.should change(EmailContent, :count).by(1)
      end

      it "should save size of body in bytes in EmailContent association" do
        @email.save
        @email.reload.email_content.bytes.should > 0
      end
      
      it "should return body and size of email" do
        @email.save
        @email.reload.body.should_not be_nil
        @email.size.should == @email.body.size
      end
    end
  end
end