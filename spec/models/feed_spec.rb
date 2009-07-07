# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feed do
  describe "on update feed" do
    before(:each) do
      @feed = create_feed_url(:rss_url => 'http://simian187.vox.com/library/posts/atom.xml').feed
    end
    
    describe "on first update" do
      it "should add all entries" do
        lambda {
          @feed.update_from_feed
        }.should change(@feed.entries, :count).from(0)
      end
    end
    
    describe "on updates after 1st save" do
      before(:each) do
        @feed.update_from_feed
      end
      
      it "should not add new entries if feed not updated" do
        lambda {
          @feed.update_from_feed
        }.should_not change(@feed.entries, :count)
      end
      
      it "should add new entries if feed last modified < new entry date" do
        latest_entry = @feed.entries.latest.first
        @feed.update_attributes(:etag => nil, :last_modified => latest_entry.published_at - 10)
        lambda {
          @feed.update_from_feed
        }.should_not change(@feed.entries, :count)
      end
    end
  end
end
