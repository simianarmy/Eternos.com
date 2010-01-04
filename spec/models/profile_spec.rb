require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

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
    include FacebookSpecHelper
    
    before(:each) do
      @profile = create_profile(:member => @member)
      @fb_profile = {:test => {:test => @member}}
    end
    
    it "should serialize facebook data on write" do
      @profile.facebook_data = @fb_profile
      @profile.save
      @profile.reload.facebook_data[:test][:test].should == @member
    end
  
    describe "synching data" do  
      before(:each) do
        @fb_user = create_facebook_user
      end
      
      it "should not raise error on sync" do
        lambda {
          @profile.sync_with_facebook(@fb_user, :political => 'foo')
        }.should_not raise_error
      end
      
      it "should sync work history" do
        lambda {
          @profile.sync_with_facebook(@fb_user, {})
        }.should change(@profile.careers, :count).by(@fb_user.work_history.size)
      end
      
      it "should not duplicate existing work history" do
        @profile.sync_with_facebook(@fb_user, {})
        lambda {
          @profile.sync_with_facebook(@fb_user, {})
        }.should_not change(@profile.careers, :count)
      end
    end
  end
end
