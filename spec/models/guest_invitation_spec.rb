# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GuestInvitation do
  include AddressBookSpecHelper
  include TimeLockSpecHelper
  
  before(:each) do
    @guest_invitation = new_guest_invitation
  end

  it "should be valid" do
    @guest_invitation.should be_valid
  end
  
  it "should not be valid without contact method" do
    @guest_invitation.contact_method = ''
    @guest_invitation.should_not be_valid
  end
  
  it "should accept an optional sender attribute" do
    new_guest_invitation(:sender => create_member).should be_an_instance_of GuestInvitation
  end
    
  describe "validating by contact method" do
    before(:each) do
      @guest_invitation.contact_method.should == 'email'
      @guest_invitation.should be_valid # Default builder with email
    end
    
    it "should require a valid email address if contact method is email" do
      @guest_invitation.email = ''
      @guest_invitation.should_not be_valid
      @guest_invitation.errors.on(:email).should_not be_blank
    end
  
    it "should require a valid phone number if contact method is phone" do
      @guest_invitation.contact_method = 'phone'
      @guest_invitation.phone_numbers.clear
      @guest_invitation.should_not be_valid
      @guest_invitation.errors.on(:phone_number).should_not be_blank
      @guest_invitation.new_phone_number_attributes = [phone_number_attrs]
      @guest_invitation.should be_valid
    end
  
    it "should require a valid address if contact method is mail" do
      @guest_invitation.contact_method = 'mail'
      @guest_invitation.should_not be_valid
      @guest_invitation.errors.on(:address).should_not be_blank
      @guest_invitation.address = new_address(:addressable => @guest_invitation)
      @guest_invitation.should be_valid
    end
  end
  
  describe "on create" do
    describe "invitation" do
      include TimeLockSpecHelper
      
      it "initial state should be pending without time lock" do
        @guest_invitation.new_time_lock_attributes = {}
        @guest_invitation.save
        @guest_invitation.should be_pending
      end
    
      it "should not be sent immediately if time/death lock set" do
        @guest_invitation.time_lock = new_time_lock(:lockable => @guest_invitation)
        @guest_invitation.save
        @guest_invitation.should be_dormant
      end
    end
    
    describe "when contact method is by phone" do
      it "should create an associated phone number objects" do
        lambda {
          @guest_invitation.new_phone_number_attributes = [phone_number_attrs, phone_number_attrs]
          @guest_invitation.save
        }.should change(PhoneNumber, :count).by(2) 
      end
    end
    
    describe "when contact method is by mail" do
      it "should create an address object" do
        lambda {
          @guest_invitation.address_attributes = valid_address_attributes
          @guest_invitation.save
        }.should change(Address, :count).by(1)
      end
    end
    
    describe "with time lock" do
      it "should create associated timelock" do
        lambda {
          @guest_invitation.new_time_lock_attributes = default_time_lock_attributes
          @guest_invitation.save
        }.should change(TimeLock, :count).by(1)
      end
    end
    
    it "should return its address object if it was created with one" do
      @guest_invitation.address_attributes = valid_address_attributes
      @guest_invitation.save
      @guest_invitation.reload.address.should_not be_new_record
    end
  end
  
  describe "on update" do
    before(:each) do
      @guest_invitation.save
      @guest_invitation.should be_pending
    end
    
    it "should save associated TimeLock on changes" do
      @guest_invitation.update_attributes(:time_lock_attributes => default_time_lock_attributes)
      @guest_invitation.reload.should be_date_locked
    end
    
    it "should call the delivery status change callback" do
      @guest_invitation.expects(:reset_delivery_status)
      @guest_invitation.update_attributes(:time_lock_attributes => default_time_lock_attributes)
    end
    
    it "should update delivery status when time lock changed" do
      @guest_invitation.expects(:set_delivery_status)
      @guest_invitation.update_attributes(:time_lock_attributes => default_time_lock_attributes)
    end
    
    describe "in pending state" do
      it "should change delivery state to dormant if time lock attribute set" do
        @guest_invitation.update_attributes(:time_lock_attributes => default_time_lock_attributes)
        @guest_invitation.time_lock.should be_an_instance_of TimeLock
        @guest_invitation.should be_dormant
      end
    end
    
    describe "in dormant state" do
      before(:each) do
        @guest_invitation.update_attributes(:time_lock_attributes => default_time_lock_attributes)
        @guest_invitation.should be_dormant
      end
      
      it "should call the delivery status change callback" do
        @guest_invitation.expects(:reset_delivery_status)
        @guest_invitation.update_attributes(:time_lock_attributes => unlocked_time_lock_attributes)
      end
      
      it "should change delivery state to pending if time lock changed to unlocked" do
        @guest_invitation.update_attributes(:time_lock_attributes => unlocked_time_lock_attributes)
        @guest_invitation.should be_pending
      end
    end
  end
end
