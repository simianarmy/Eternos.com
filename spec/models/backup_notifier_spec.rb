# $Id$

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BackupNotifier do
  before(:each) do
    set_mailer_in_test
  
    @site = AppConfig.base_domain
    @user = mock_model(Member)
    @user.stubs(:email).returns('user@test.com')
  end
  
  describe "timeline_ready" do
    before(:each) do
      @notifier = BackupNotifier.create_timeline_ready(@user)
    end
    
    describe "on create" do
      it "should set recipient to user email address" do
        @notifier.to.should eql( ["user@test.com"] )
      end
      
      it "should use email layout with full url to image assets" do
        @notifier.body.should match(/url\('#{ActionController::Base.asset_host}.+\.gif'\)/)
      end
    end
  end
end
