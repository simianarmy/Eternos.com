# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

describe AddressBook do
  include AddressBookSpecHelper
  it_should_behave_like "a mocked member is signed in"
  
  before(:each) do
    @address_book = new_address_book(:user => @member)
  end

  it "should not be valid without required attributes" do
    @address_book.should be_valid
    @address_book.attributes = valid_address_book_attributes(:first_name => '')
    @address_book.should_not be_valid
  end
  
  it "should be encrypted if binary field" do
    @address_book.ssn = '444' # col name is ssn_b
    @address_book.save
    @address_book.ssn.should == '444'
  end
  
  it "should build an address if queried for one when none exist" do
    @address_book.home_address.should be_an_instance_of Address
  end

  describe "on create" do
    before(:each) do
      @address_book.save
    end
    
    describe "on update_attributes" do
      it "should not add address if attributes are invalid" do
        @address_book.update_attributes(:address_attributes => {})
        @address_book.should_not be_valid
      end
    end
  end
  
  describe "with one address" do 
    before(:each) do
      @address_book.save
    end
  
    it "should have one address" do 
      @address_book.addresses.first.should be_valid
    end
  
    it "should only have one associated address" do
      @address_book.addresses.size.should == 1
    end
  
    it "should fail on trying to update address with invalid attributes" do
      id = @address_book.addresses.first.id
      @address_book.update_attributes(:address_attributes => {:id => id,:street_1 => ''})
      @address_book.errors.should_not be_empty
    end
  
    it "should return updated address object after save" do
      id = @address_book.addresses.first.id
      @address_book.update_attributes(:address_attributes => {:id => id,:street_1 => 'new jack'})
      @address_book.addresses.first.reload.street_1.should eql('new jack')
    end
  
    it "should return valid home address when queried" do
      @address_book.home_address.should be_an_instance_of Address
    end
  end

  describe "with phone number" do
    before(:each) do
      @address_book = create_user_details(@user)
    end
  
    it "should create phone number object" do
      lambda {
        @address_book.update_attributes(create_new_phone_number_attrs)
      }.should change(PhoneNumber, :count).by(1)
    end
  
    it "should have associated phone number object" do
      @address_book.update_attributes(create_new_phone_number_attrs)
      @address_book.phone_numbers.first.should be_valid
    end
  end
  
  describe "synching from facebook" do
    include FacebookSpecHelper
    
    before(:each) do
      @address_book.save
      @fb_user = create_facebook_user
    end
    
    describe "without locations" do
      before(:each) do
        @fb_user.expects(:current_location).returns(nil)
        @fb_user.expects(:hometown_location).returns(nil)
      end
      
      it "should not sync any empty attributes" do
        @address_book.sync_with_facebook(@fb_user, {})
        @address_book.first_name.should_not be_blank
      end

      it "should sync any non-empty attributes" do
        @address_book.sync_with_facebook(@fb_user, {:first_name => 'hooey'})
        @address_book.reload.first_name.should == 'hooey'
      end

      it "should sync birthdate from date string" do
        @address_book.sync_with_facebook(@fb_user, {:birthday_date => "05/11/1970"})
        @address_book.reload.birthdate.year.should == 1970
      end
    end
    
    describe "with location(s)" do
      def create_location
        stub('Location', :city => 'seattle', :zip => {}, :state => "Oregon", :country => "Foostan")
      end
      
      def create_region
        mock_model(Region, :country => @country = mock_model(Country))
      end
      
      before(:each) do
        @fb_user.expects(:current_location).returns(@loc = create_location)
        @fb_user.expects(:hometown_location).returns(nil)
      end
      
      describe "with valid region value" do
        before(:each) do
          Region.expects(:find_by_name).with(@loc.state).returns(@region = create_region)
        end

        it "should add current location if nonempty" do
          lambda {
            @address_book.sync_with_facebook(@fb_user, {})
            }.should change(@address_book.addresses, :count).by(1)
        end
        
        it "should not add address if duplicate address already exists" do
          @address_book.addresses << create_address(:city => @loc.city, :postal_code => @loc.zip.to_s, :country_id => @country.id, :region_id => @region.id)
          @address_book.save
          lambda {
            @address_book.sync_with_facebook(@fb_user, {})
          }.should_not change(@address_book.addresses, :count)
        end
      end
      
      describe "with unknown region" do
        before(:each) do
          Region.expects(:find_by_name).with(@loc.state).returns(nil)
        end
        
        it "should add location using default region" do
          @address_book.expects(:default_region).returns(@region = create_region)
          @address_book.sync_with_facebook(@fb_user, {})
          @address_book.addresses.last.country_id.should == @country.id
        end
      end
    end
  end
end
