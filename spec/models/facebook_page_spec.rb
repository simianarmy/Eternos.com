# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FacebookPage do
  let ( :fb_page_proxy ) {
    FacebookProxyObjects::FacebookerPageProxy.new(
      Facebooker::Page.new(:page_id => 1, :name => 'some page', :page_url => 'some url'))
  }
  let ( :user ) { create_member }
  
  describe "on create_from_proxy" do
    describe "with invalid proxy data" do
      it "should fail silently if passed nil data" do
        lambda {
          FacebookPage.create_from_proxy(nil, nil)
        }.should_not raise_error
      end
    
      it "should fail silently if proxy object does not have required attributes" do
        lambda {
          FacebookPage.create_from_proxy(fb_page_proxy)
        }.should_not raise_error
      end
      
      it "should create audit trail" do
        lambda {
          FacebookPage.create_from_proxy(fb_page_proxy)
        }.should change(Audit, :count).by(1)
      end
      
      it "should save account owner in audit trail if specified" do
        fp = FacebookPage.create_from_proxy(fb_page_proxy, @user = user)
        fp.audits.last.user.should == @user
      end
    end
    
    describe "with valid proxy data" do
      before(:each) do
        @fb_page = fb_page_proxy
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
      
      it "should create a record with optional user argument for auditing" do
        @user = user
        page = FacebookPage.create_from_proxy(@fb_page, @user)
        page.audits.count.should be(1)
        page.audits.each { |audit| audit.user.should == @user }
      end
      
      it "should save all proxy attributes as hash to serialized column" do
        @fb_page.pic_small = 'somewhere'
        @fb_page.starring = 'me'
        obj = FacebookPage.create_from_proxy(@fb_page)
        obj.page_data.pic_small.should == 'somewhere'
        obj.page_data.starring.should == 'me'
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
      @page = FacebookPage.create_from_proxy(@fb_page = fb_page_proxy, user)
    end
    
    it "should not synch if page ids are not equal" do
      @fb_page.page_id = 2
      @page.synch_with_proxy(@fb_page, user).should be_false
    end
    
    it "should not synch if proxy object does not have required attributes" do
      @fb_page.name = nil
      @page.synch_with_proxy(@fb_page, user).should be_false
    end
    
    it "should synch required attributes" do
      @page.stubs(:too_soon_since_last_synch?).returns(false)
      @fb_page.name = 'foop'
      @fb_page.page_url = 'url'
      @page.synch_with_proxy(@fb_page, user)
      @page.name.should == @fb_page.name
      @page.url.should == @fb_page.page_url
    end
    
    it "should not synch unless min time delay has elapsed" do
      @page.synch_with_proxy(@fb_page, user).should be_false
      @page.too_soon_since_last_synch?.should be_true
    end
    
    it "should synch if min time delay has elapsed" do
      @page.updated_at -= @page.min_synch_delay 
      @page.too_soon_since_last_synch?.should be_false
    end
  end
end