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
        @feed.update_from_feed
        @feed.expects(:add_entries).never
      end
      
      it "should add new entries only" do
        @feed.entries.latest.first.destroy
        recent = @feed.entries.reload.latest.first
        @feed.update_attributes(:etag => nil, :last_modified => recent.published_at)
        lambda {
          @feed.update_from_feed
        }.should change(@feed.entries, :count).by(1)
      end
    end
  end
end
