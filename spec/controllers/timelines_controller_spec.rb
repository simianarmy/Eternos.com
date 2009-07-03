# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe TimelinesController do
  #integrate_views
  describe "for members" do
    it_should_behave_like "a mocked member is signed in"
  
    before(:each) do    
    end
  
    describe "on search" do
      def do_search(opts={})
        xhr :get, :search, :id => @member.id, :start_date => opts[:start] || Date.today,
          :end_date => opts[:end] || Date.today, :filters => opts[:filters]
      end
      
      def parse_response(response)
        ActiveSupport::JSON.decode(response.body).symbolize_keys!
      end
      
      before(:each) do
      end
      
      it "should return JSON response object with request uri" do
        do_search
        res = parse_response(response)
        res[:request].should match(%r(http://#{@request.host}/timeline/search/#{@member.id}))
      end
      
      describe "fake requests" do
        it "should return empty results when empty param present" do
          do_search :filters => [:fake, :empty, 'user_id=1']
          res = parse_response(response)
          res[:resultCount].should == 0
        end
        
        it "should return results without when no empty param" do
          do_search :filters => [:fake, 'user_id=1']
          res = parse_response(response)
          res[:resultCount].should > 0
          res[:results].should_not be_empty
        end
      end
    end
  end
end