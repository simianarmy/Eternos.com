# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe User, "" do
  
  it "should be created" do
    lambda{ 
        user = create_user 
        user.should_not be_new_record 
    }.should change(User,:count).by(1)
  end
  
  it "should require first & last name" do
    u = new_user(:first_name => nil)
    u.should have(1).errors_on(:first_name)
    u = new_user(:last_name => nil)
    u.should have(1).errors_on(:last_name)
  end
  
  it "should require password" do
    u = new_user(:password => '')
    u.should have_at_least(1).errors_on(:password)
  end

  it "should require password confirmation" do
    u = new_user(:password_confirmation => nil)
    u.should have_at_least(1).errors_on(:password_confirmation)
  end

  it "should require password of minimum length (6)" do
    u = new_user(:password => "12345")
    u.should have_at_least(1).errors_on(:password)
  end
  
  it "should require email" do
    u = new_user(:email => nil)
    u.should have_at_least(1).errors_on(:email)
  end
  
  describe "with info from facebook connect only" do
    it "should be valid if creating from facebook connect only" do
      u = new_user(:facebook => 1)
      u.password.should be_blank
      u.should be_valid
    end
  end
  
  describe "when created" do
    before(:each) do
      @user = create_user
    end
    
    it "should create crypted password" do
      @user.crypted_password.should_not be_blank
    end
    
    it "should not create an account" do
      @user.account.should be_nil
    end
    
    it "should be pending" do
       @user.should be_pending
     end
     
    it "should return full name" do
      @user.name.should_not be_empty
      @user.full_name.should == @user.name
    end
    
    it "should not be activated" do
      @user.should_not be_recently_activated
    end
  
    it "should allow activation" do
      @user.should_not be_recently_activated
      @user.activate!
      @user.should be_recently_activated
    end
  
    it "should not be member until activated" do
      @user.should_not be_member
      @user.activate!
      @user.should be_member
    end
  
    it "should have associated address book object" do
      @user.address_book.should_not be_nil
      @user.address_book.first_name.should == @user.first_name      
      @user.address_book.last_name.should == @user.last_name
    end
    
    it "should call UserMailer.deliver_activation when activated" do
      UserMailer.expects(:deliver_activation).with(@user)
      @user.activate!
    end
  end
  
  describe "when created from facebook connect info" do
    before(:each) do
      @user = create_user(:facebook => 1)
    end
    
    it "should be facebook user" do
      @user.should be_facebook_user
    end
    
    it "should not have a password" do
      @user.crypted_password.should be_blank
    end
  end
end



 
 
