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
      
      describe "on save_html" do
        before(:each) do
          @content.save_html
        end

        it "should download html contents of url" do
          @content.html_content.should_not be_blank
        end

        it "bytes should return nonzero" do
          @content.bytes.should > 0
        end
      end
      
      describe "on save_screencap" do
        it "screencap_url should return blank string if no screencap image" do
          @content.screencap_url.should be_blank
        end
            
        it "should return url to s3 image after screencapture" do
          @content.save_screencap
          @content.screencap_url.should match(/s3/)
        end
        
        it "should have a size attribute > 0" do
          @content.save_screencap
          @content.size.should > 0
        end
        
        it "bytes should be set to the screencap file size" do
          @content.save_screencap
          @content.bytes.should == @content.size
        end
      end
    end
  end
end
