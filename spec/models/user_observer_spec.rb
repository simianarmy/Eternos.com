# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe UserObserver, "A UserObserver" do
  before(:each) do
    @user = mock('user')
    @user_observer = UserObserver.instance
  end

  specify "should call UserMailer.deliver_signup_notification on user creation" do
    @user.expects(:send_signup_notification?).returns(true)
    UserMailer.expects(:deliver_signup_notification).with(@user)
    @user_observer.after_create(@user)
  end
  
  # specify "should call UserMailer.deliver_activation if user was recently activated" do
  #     UserMailer.expects(:deliver_activation).with(@user)
  #     @user.stubs(:recently_activated?).returns(true)
  #     @user_observer.after_save(@user)
  #   end
  #   
  #   specify "should not call UserMailer.deliver_activation if user wasn't recently activated" do
  #     UserMailer.expects(:deliver_activation).never
  #     @user.stubs(:recently_activated?).returns(false)
  #     @user_observer.after_save(@user)
  #   end
end

