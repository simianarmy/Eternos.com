# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../timeline_event_spec_helper')

describe MedicalCondition do
  include UserSpecHelper
  before(:all) do
    @member = make_member
  end
  
  describe "on create" do
    it "should belong to a profile" do
      @md = new_medical_condition
      @md.profile.should be_a Profile
    end
    
    it "should create a new instance given valid attributes" do
      lambda {
        create_medical_condition(:profile => @member.profile)
      }.should change(MedicalCondition, :count).by(1)
    end
  end
  
  describe "" do
    before(:each) do
      @tl_event = @md = create_medical_condition(:profile => @member.profile)
    end
    
    it_should_behave_like "a timeline event"

    describe "as JSON object" do
      before(:each) do
        @json = @md.to_json
      end

      it "should contain required attributes" do
        @obj = ActiveSupport::JSON.decode(@json)

        @obj['name'].should_not be_blank
      end
    end
  end
end