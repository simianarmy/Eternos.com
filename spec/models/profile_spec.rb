require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ProfileSpecHelper
  def valid_attributes(options={})
    options
  end
end

describe Profile do
  include ProfileSpecHelper
  before(:each) do
    @profile = Profile.new
    @member = create_member
  end

  it "should not be valid without parent member" do
    @profile.should_not be_valid
    @profile.attributes = valid_attributes(:member=>@member)
    @profile.should be_valid
  end
end
