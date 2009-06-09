# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GuestsController do
  it_should_behave_like "a member is signed in"
  
  include GuestSpecHelper
  include AddressBookSpecHelper
  
  def guest_post_attributes(options={})
    valid_guest_attributes.merge(:circle_id => @guest_circle.id).merge(options)
  end
  
  it "index action should render index template" do
    @member.expects(:loved_ones).returns([@guest = create_guest_with_host(@member)])
    GuestInvitation.stubs(:unconfirmed).returns([create_guest_invitation(:sender => @member)])
    @new_invitation = new_guest_invitation(:sender => @member)
    GuestInvitation.stubs(:new).returns(@new_invitation)

    get :index
    assigns[:guests].should == [@guest]
    assigns[:invitation].should == @new_invitation
    assigns[:invitations].should have(1).thing
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    Guest.expects(:find).with("1", anything).returns(@guest = mock_model(Guest))
    @guest.expects(:current_host_id=).with(@member.id)
    get :show, :id => "1"
    assigns[:guest].should == @guest
    response.should render_template(:show)
  end

  describe "" do 

    describe "on update" do
      integrate_views
      
      before(:each) do
        Guest.expects(:find).with("1", anything).returns(@guest = create_guest_with_host(@member))
      end
      
      it "should display success flash message with valid attributes " do
        @guest.expects(:update_attributes).returns(true)
        xhr :post, :update, :id => "1", :guest => {}
        assert_rjs :replace_html, :notice
      end
    
      it "should replace guest name when name changed" do
        xhr :post, :update, :id => "1", :guest => valid_guest_attributes
        assert_rjs :replace_html, controller.dom_id(@guest) + "_name"
      end
    
      it "should replace relationship name display row when new relationship entered" do
        xhr :post, :update, :id => "1", :guest => valid_guest_attributes.merge(:new_circle_name => 'test')
        assert_rjs :replace_html, controller.dom_id(@guest) + "_relationship", 'test'
      end
      
      it "should update address fields" do
        @guest.address_book.expects(:update_attributes).with('address_attributes' => @address = valid_address_attributes).returns(true)
        xhr :post, :update, :id => "1", :guest => valid_guest_attributes.merge(
          :address_book => {:address_attributes => @address})
      end
      
      it "should create address object when address entered" do
        lambda {
          xhr :post, :update, :id => "1", :guest => valid_guest_attributes.merge(
            :address_book => {:address_attributes => valid_address_attributes})
        }.should change(Address, :count).by(1)
      end
      
      it "should update address object when address updated" do
        @guest.address_book.addresses.create(valid_address_attributes)
        addr_id = @guest.address_book.addresses.first.id
        addr_id.should_not be_nil
        lambda {
          xhr :post, :update, :id => "1", :guest => valid_guest_attributes.merge(
            :address_book => {:address_attributes => valid_address_attributes.merge(:id => addr_id)})
        }.should_not change(Address, :count)
      end
    end
  end
end
