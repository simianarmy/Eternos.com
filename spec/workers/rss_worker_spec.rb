# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe RssWorker do
  
  describe "on fetch_blog_contents" do
    def call_worker(id=1)
      RssWorker.new.fetch_blog_contents(:id => id)
    end
    
    before(:each) do
      @item = create_feed_content
      FeedEntry.any_instance.stubs(:url).returns('http://simian187.vox.com/library/post/os-x-time-machine-problems.html')
    end
    
    it "should upload backup email to s3" do
      call_worker(@item.id)
      @item.reload.html_content.should_not be_blank
      @item.screencap.url.should match(/s3/)
    end
  end
end