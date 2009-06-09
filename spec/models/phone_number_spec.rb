# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhoneNumber do
  fixtures :all
  
  before(:each) do
    @phone_number = PhoneNumber.new
  end

  it "should not be valid on init" do
    @phone_number.should_not be_valid
  end
  
  it "should be valid with type and number" do
    phone_numbers(:us_home).should be_valid
  end
end
