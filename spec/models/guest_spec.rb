# $Id$
# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe Guest, "" do
  include GuestSpecHelper
  include AddressBookSpecHelper
  
  describe "" do
    before(:each) do
      @guest = new_guest_with_host
    end

    describe "on create" do
      it "should not be valid without required attributes" do
        @guest.should be_valid
        @guest.circle = nil
        @guest.should_not be_valid
      end
      
      it "should not be valid if creating without specifying a host" do
        @guest.should be_valid
        @guest.current_host_id = nil
        @guest.save
        @guest.should_not be_valid
      end
    
      it "should be emergency contact for member if requested" do
        @guest.emergency_contact = true
        @guest.save
        @guest.should be_emergency_contact_for(@member)
      end
      
      it "should create address book" do
        lambda {
          @guest.save
        }.should change(AddressBook, :count).by(1)
      end
    end
  end
  
  describe "" do
    before(:each) do
      @guest = create_guest_with_host
    end
  
    describe "after create" do
      it "should not be emergency contact for member by default" do
        @guest.should_not be_emergency_contact_for(@member)
      end
      
      it "should create address book with first & last name if not in attributes" do
        @guest.address_book.first_name.should == @guest.first_name
        @guest.address_book.last_name.should == @guest.last_name
      end
  
      it "should return a relationship object that belongs to the host" do
        @guest.relationship.member.should == @member
      end
  
      it "should be able to find its current circle" do
        @guest.current_circle.should == @circle
      end
  
      it "should be pending" do
        @guest.should be_pending
      end
  
      it "should be associated with its host" do
        @guest.hosts.first.should == @member
      end
  
      it "should have one relationship" do
        @guest.relationships.size.should == 1
      end
  
      it "should be a guest of its host" do
        @guest.get_host.should == @member
      end
  
      it "should have one circle" do
        @guest.circles.size.should == 1
      end
  
      it "should return a circle through its relationship" do
        @guest.current_circle.should == @circle
      end
    end
  
    describe "with more that one host" do
      it "can belong to more than one host" do
        lambda {
          create_member.add_guest @guest, @circle
        }.should change(GuestRelationship, :count).by(1)
      end
  
      it "should return relationship associated with host" do
        other = create_member
        other.add_guest @guest, @circle
        @guest.hosts.size.should == 2
        @guest.get_host(other.id).should == other
        @guest.relationship(other).should_not == @guest.relationship(@member)
      end
    end
  
    describe "on update" do
      it "should update its relationship" do
        another_circle = create_circle(:user_id => @member.id)
        @guest.update_attributes(:circle_id => another_circle.id)
        @guest.reload.current_circle.should == another_circle
      end
    end
  end
end