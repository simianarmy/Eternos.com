require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedContent do
  describe "on new" do
    before(:each) do
      @content = new_feed_content
    end

    describe "on create" do
      # Never works in test env
      it "should call after_commit_on_create callback" do
        #@content.expects(:after_commit_on_create)
        #@content.save
      end
    end
    
    describe "after create" do
      before(:each) do
        @content.stubs(:feed_entry).returns(stub(:url => 'http://simian187.vox.com/library/post/os-x-time-machine-problems.html'))
        @content.save.should be_true
      end

      it "should download html contents of url" do
        @content.save_html
        @content.html_content.should_not be_blank
      end

      describe "screencap_url" do
        it "should return blank string if no screencap image" do
          @content.screencap_url.should be_blank
        end
            
        it "should return url to s3 image after screencapture" do
          @content.save_screencap
          @content.screencap_url.should match(/s3/)
        end
      end
    end
  end
end
