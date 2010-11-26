# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

describe FacebookAccount do
  include FacebookSpecHelper
  
  describe "on create" do
    before(:each) do
      @acc = create_facebook_account(:member => create_member)
    end
  
    it "should have the right type and be valid" do
      @acc.should be_a FacebookAccount
      @acc.should be_valid
    end
  end
  
  describe "adding pages" do
    before(:each) do
      @acc = create_facebook_account(:member => create_member)
      @pages = [create_facebooker_page, create_facebooker_page]
    end
    
    describe "on save_administered_pages" do
      it "should create an associated page record for each unique facebooker page" do
        lambda {
          @acc.save_administered_pages(@pages)
        }.should change(@acc.pages, :count).by(@pages.size)
      end
      
      it "should not create new page records if the page already exists" do
        @acc.save_administered_pages(@pages)
        lambda {
          @acc.save_administered_pages(@pages)
        }.should_not change(@acc.pages, :count)
      end
      
      it "if a page has changed, it should synch the new data to the page object" do
        @acc.save_administered_pages(@pages)
        pg = @pages.first
        pg.stubs(:page_url).returns('something.else')
        FacebookPage.any_instance.stubs(:too_soon_since_last_synch?).returns(false)
        @acc.save_administered_pages([pg])
        @acc.pages.find_by_page_id(pg.page_id).url.should == 'something.else'
      end
      
      it "should not create a new page even if saved by new account" do
        @acc.save_administered_pages(@pages)
        acc2 = create_facebook_account(:member => create_member)
        lambda {
          acc2.save_administered_pages(@pages)
        }.should_not change(FacebookPage, :count)
      end
    
      it "should create a new association for a different user than the original page creator" do
        @acc.save_administered_pages(@pages)
        acc2 = create_facebook_account(:member => create_member)
        lambda {
          acc2.save_administered_pages(@pages)
        }.should change(acc2.pages, :count).by(@pages.size)
      end
    end
  end
end
