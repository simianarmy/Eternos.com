# $Id$
require File.dirname(__FILE__) + '/../spec_helper'
#0require "#{RAILS_ROOT}/app/models/user_mailer"


describe UserMailer, "A UserMailer on signup_notification" do
  before(:each) do
    set_mailer_in_test
    
    @site = AppConfig.base_domain
    @user = mock("user")
    @user.stubs(:email).returns('user@test.com')
    @user.stubs(:activation_code).returns('code')
    @user.stubs(:login).returns('user')
    @user.stubs(:password).returns('password')
    
    @user_notifier = UserMailer.create_signup_notification(@user)
  end
  
  specify "should set @recipients to user's email" do
    @user_notifier.to.should eql( ["user@test.com"] )
  end
  
  specify "should set @subject to [#{@site}] Please activate your new account" do
    @user_notifier.subject.should eql( "[#{@site}] Please activate your new account" )
  end
  
  specify "should set @from to from_email" do
    @user_notifier.from.should eql( ["#{AppConfig.from_email}"])
  end
  
  specify "should contain user activation url (http://#{@site}/activate/code) in mail body" do
    @user_notifier.body.should match( %r{http://#{@site}/activate/code} )
  end
end

context "A UserMailer on activation" do
  before(:each) do
    set_mailer_in_test
    
    @site = AppConfig.base_domain
    @user = mock("user")
    @user.stubs(:email).returns('user@test.com')
    @user.stubs(:login).returns('user')
    @user.stubs(:password).returns('password')
    
    @user_notifier = UserMailer.create_activation(@user)
  end
  
  specify "should set @recipients to user's email" do
    @user_notifier.to.should eql( ["user@test.com"])
  end
  
  specify "should set @subject to [YOURSITE] Your account has been activated!" do
    @user_notifier.subject.should eql( "Your #{AppConfig.app_name} account has been activated!")
  end
  
  specify "should set @from to from_email" do
    @user_notifier.from.should eql( ["#{AppConfig.from_email}"])
  end
  
   specify "should contain login reminder (Login: user) in mail body" do
    @user_notifier.body.should match( /Login: user/ )
  end
  
  specify "should contain website url (http://YOURSITE/) in mail body" do
    @user_notifier.body.should match( %r{#{@site}})
  end
end
