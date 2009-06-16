require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ProfileSpecHelper
  def valid_attributes(options={})
    options
  end
end

describe Profile do
  include ProfileSpecHelper
  before(:each) do
    @member = create_member
    @profile = new_profile(:member => @member)
  end

  it "should not be valid without parent member" do
    new_profile(:member => nil).should_not be_valid
    @profile.should be_valid
  end
  
  describe "with facebook data" do
    before(:each) do
      @profile = create_profile(:member => @member)
      @fb_profile = {:test => {:test => @member}}
    end
    
    it "should serialize facebook data on write" do
      @profile.facebook_data = @fb_profile
      @profile.save
      @profile.reload.facebook_data[:test][:test].should == @member
    end
  end
end
