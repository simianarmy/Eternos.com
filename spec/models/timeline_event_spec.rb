require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'timeline_search'

describe TimelineEvent do
  include TimelineSearchSpecHelper
    
  before(:all) do
    @member = Member.first
    @start_date = '2008-01-01'
    @end_date   = '2012-12-31'
  end
  
  def do_search(opts={})
    new_fake_search(@member, @start_date, @end_date, opts)
  end
  
  describe "a content event" do
    it "should contain url attributes" do
      @res = do_search(:type => 'photos').results.first
      @res.attributes[:url].should_not be_blank
      @res.attributes[:thumbnail_url].should_not be_blank
    end
  end 
end
