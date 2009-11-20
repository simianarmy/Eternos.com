# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../timeline_event_spec_helper')

describe Address do
  it "should create a new instance given valid attributes" do
    lambda {
      create_address
    }.should change(Address, :count).by(1)
  end
  
  describe "on create" do
    describe "with validatable location" do
      before(:each) do
        @address = Address.new(:location_type => Address::Home)
      end
      
      it "should have a validatable location type" do
        @address.should be_validatible_location
      end
      
      it "should require all street address attributes" do
        @address.street_1 = 'helltown'
        @address.city = 'Bellevue'
        @address.should_not be_valid
        @address.country_id = 1
        @address.should be_valid
      end
    end
    
    describe "with non-validatable location" do
      before(:each) do
        @address = Address.new(:location_type => Address::Birth)
      end
      
      it "should not have a validatable location type" do
        @address.should_not be_validatible_location
      end
      
      it "should require only one street address attribute" do
        @address.should_not be_valid
        @address.street_1 = 'helltown'
        @address.should be_valid
      end
    end
  end
  
  describe "" do
    before(:each) do
      @tl_event = @address = create_address
    end
    
    it "should return full postal address" do
      postal_bits = @address.postal_address.split("\n")
      postal_bits[1].should match(/#{@address.street_1}/)
      postal_bits[2].should match(/#{@address.city}/)      
    end
    
    describe "as JSON object" do
      before(:each) do
        @json = @address.to_json
      end

      it "should contain address attributes" do
        @obj = ActiveSupport::JSON.decode(@json)
        @obj['street_1'].should_not be_blank
        @obj['city'].should_not be_blank
        @obj['postal_address'].should_not be_blank
      end
    end
    
    it_should_behave_like "a timeline event"
  end
end