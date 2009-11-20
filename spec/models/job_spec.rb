# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../timeline_event_spec_helper')

describe Job do
  include UserSpecHelper
  before(:all) do
    @member = make_member
    @member.profile.should be_a Profile
  end
  
  describe "on create" do
    it "should belong to a profile" do
      @job = new_job
      @job.profile.should be_a Profile
    end
    
    it "should create a new instance given valid attributes" do
      lambda {
        create_job(:profile => @member.profile)
      }.should change(Job, :count).by(1)
    end
  end
  
  describe "" do
    before(:each) do
      @tl_event = @job = create_job(:profile => @member.profile)
    end
    
    it_should_behave_like "a timeline event"

    describe "as JSON object" do
      before(:each) do
        @json = @job.to_json
      end

      it "should contain required attributes" do
        @obj = ActiveSupport::JSON.decode(@json)

        @obj['company'].should_not be_blank
        @obj['title'].should_not be_blank
      end
    end
  end
end