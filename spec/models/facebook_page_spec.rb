# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookPage do
  describe "on create_from_proxy" do
    describe "with invalid proxy data" do
      it "should fail silently if passed nil data" do
        lambda {
          FacebookPage.create_from_proxy(nil)
        }.should_not raise_error
      end
    
      it "should fail silently if proxy object does not have required attributes" do
        lambda {
          FacebookPage.create_from_proxy(Facebooker::Page.new)
        }.should_not raise_error
      end
    end
    
    describe "with valid proxy data" do
      before(:each) do
        @fb_page = Facebooker::Page.new(:page_id => 1, :name => 'some page', :page_url => 'some url')
      end
      
      it "should contain required attributes" do
        obj = FacebookPage.create_from_proxy(@fb_page)
        obj.should be_valid
      end
      
      it "should create a record when proxy has required attributes" do
        lambda {
          FacebookPage.create_from_proxy(@fb_page)
        }.should change(FacebookPage, :count).by(1)
      end
      
      it "should save all proxy attributes as hash to serialized column" do
        @fb_page.pic_small = 'somewhere'
        @fb_page.starring = 'me'
        obj = FacebookPage.create_from_proxy(@fb_page)
        obj.page_data['pic_small'].should == 'somewhere'
        obj.page_data['starring'].should == 'me'
      end
      
      it "should save proxy genre class data in serialized column" do
        @fb_page.genre = Facebooker::Page::Genre.new(:dance => '1', :think => '0')
        obj = FacebookPage.create_from_proxy(@fb_page)
        
        obj.page_data['genre'].should be_a Facebooker::Page::Genre
        obj.page_data['genre'].dance.should be_true
        obj.page_data['genre'].think.should be_false
      end
    end
  end
  
  describe "synching from proxy" do
    before(:each) do
      @fb_page = Facebooker::Page.new(:page_id => 1, :name => 'some page', :page_url => 'some url')
      @page = FacebookPage.create_from_proxy(@fb_page)
    end
    
    it "should not synch if page ids are not equal" do
      @fb_page.page_id = 2
      @page.synch_with_proxy(@fb_page).should be_false
    end
    
    it "should not synch if proxy object does not have required attributes" do
      @fb_page.name = nil
      @page.synch_with_proxy(@fb_page).should be_false
    end
    
    it "should synch required attributes" do
      @page.stubs(:too_soon_since_last_synch?).returns(false)
      @fb_page.name = 'foop'
      @fb_page.page_url = 'url'
      @page.synch_with_proxy(@fb_page)
      @page.name.should == @fb_page.name
      @page.url.should == @fb_page.page_url
    end
    
    it "should not synch unless min time delay has elapsed" do
      @page.synch_with_proxy(@fb_page).should be_false
      @page.too_soon_since_last_synch?.should be_true
    end
    
    it "should synch if min time delay has elapsed" do
      @page.updated_at -= @page.min_synch_delay 
      @page.too_soon_since_last_synch?.should be_false
    end
  end
end