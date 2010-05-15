# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe TimelinesController do
  #integrate_views
  describe "for members" do
    before(:each) do    
    end
  
    describe "on index" do
      it_should_behave_like "a member is signed in"
      
      before(:each) do
      end
      
      it "should set member timeline span dates" do
        Member.any_instance.expects(:timeline_span).returns([10.days.ago.to_date, Date.today])
        get :show
        assigns[:tl_start_date].should == 10.days.ago.to_date
      end
      
      it "should set member full name instance" do
        Member.any_instance.stubs(:full_name).returns("John Smith")
        get :show
        assigns[:member_name].should == "John Smith"
      end
    end
    
    describe "on search" do
      it_should_behave_like "a member is signed in"
      
      def do_search(opts={})
        xhr :get, :search, :id => @member.id, :start_date => opts[:start] || Date.today,
          :end_date => opts[:end] || Date.today, :filters => opts[:filters]
      end
      
      def parse_response(response)
        # Weird buth we have to decode json twice..
        ActiveSupport::JSON.decode(ActiveSupport::JSON.decode(response.body)).symbolize_keys!
      end
      
      before(:each) do
        # mock search activity
        TimelineRequestResponse.stubs(:new).returns(mock('TimelineRequestResponse', :execute => @search_results = stub(:search_reponse)))
        @search_results.stubs(:as_json).returns({:request => '/search', :results => [], :resultCount => 5}.to_json)
      end
      
      describe "refresh_timeline session set" do
        before(:each) do
          controller.force_cache_reload!(:timeline)
        end
        
        it "should clear the timeline cache buster session key" do
          do_search
          controller.force_cache_reload?(:timeline).should be_false
        end
      end
      
      it "should return JSON response object with request uri" do
        do_search
        res = parse_response(response)
        res[:request].should == '/search'
      end
      
      describe "fake requests" do
        it "should return empty results when empty param present" do
          do_search :filters => ['fake=1', 'empty=1', 'user_id=1']
          res = parse_response(response)
          res[:resultCount].should == 5
        end
        
        it "should return results without when no empty param" do
          do_search :filters => ['fake=1', 'user_id=1']
          res = parse_response(response)
          res[:resultCount].should == 5
        end
      end
    end
  end
end