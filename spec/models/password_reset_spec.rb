require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordReset do
  fixtures :accounts
  
  before(:each) do
    set_mailer_in_test
    @account = accounts(:localhost)
    @account.stubs(:users).returns([@user = create_member])
  end
  
  it "should get a token when created" do
    @pr = PasswordReset.create(:user => @user)
    @pr.token.should_not be_blank
  end
  
  it "should send an email when created" do
    SubscriptionNotifier.expects(:deliver_password_reset)
    PasswordReset.create(:user => @user)
  end
end