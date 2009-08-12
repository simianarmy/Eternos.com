# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe TimelineSearch do
end

describe TimelineSearchFaker do
  include TimelineSearchSpecHelper
    
  before(:all) do
    @member = Member.first
    @start_date = '2008-01-01'
    @end_date   = '2012-12-31'
  end
  
  def do_search(opts={})
    new_fake_search(@member, @start_date, @end_date, opts)
  end
  
  describe "on new" do
    it "should return all types if no type param" do
      @search = do_search
      @search.search_types.should == TimelineSearch.type_action_map.keys
    end
    
    it "should return selected type if type param" do
      @search = do_search :type => "email"
      @search.search_methods.should == [TimelineSearch.type_action_map[:email]]
    end
    
    it "should return selected types if type param with multiple types" do
      @search = do_search :type => "email|twitter"
      @search.search_methods.should == [TimelineSearch.type_action_map[:email], 
        TimelineSearch.type_action_map[:twitter]]
    end
    
    it "should only return artifact types if artifact flag is set" do
      @search = do_search :artifact => true
      @search.search_methods.should == TimelineSearch.filter_action_map[:artifact]
    end
    
    it "should only return duration types if duration flag is set" do
      @search = do_search :duration => true
      @search.search_methods.should == TimelineSearch.filter_action_map[:duration]
    end
    
    it "should set default number of results to return to max" do
      do_search.num_results.should == TimelineSearch.max_results
    end
    
    it "should set number of results to return if in options" do
      do_search(:max_results => 101).num_results.should == 101
    end
  end
  
  describe "generating results" do
    before(:each) do
      @search = do_search
    end
    
    it "should return array with max_results items" do
      # Need profile data in test db, should == max_results+1
      @search.results.size.should be_close(TimelineSearch.max_results, 2)
    end
    
    it "should return media only if artifacts flag is set" do
      events = do_search(:artifact=>true).results
      events.should_not be_empty
      events.each do |e|
        ['FacebookActivityStreamItem', 'Photo', 'Video'].should include e.type
      end
    end
    
    it "should return duration events only if duration flag is set" do
      events = do_search(:duration=>true).results
      events.should_not be_empty
      events.each do |e|
        ['Address', 'Job', 'School'].should include e.type
        if e.end_date
          e.end_date.should == Date.parse(@end_date)
        end
      end
    end
  end
end
      