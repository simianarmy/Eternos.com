require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/index.html.erb" do
  include ProfilesHelper
  
  before(:each) do
    @profile = mock('ProfilePresenter')
    @profile.stubs(:address_book).returns(@address_book = mock('AddressBook'))
    @profile.stubs(:phone_numbers).returns([])
    assigns[:profile] = @profile
  end

  it "should render display address book form" do
    @profile.stubs(:errors).returns([])
    #render "/profiles/_personal.html.erb"
  end
end