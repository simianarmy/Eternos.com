# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

require 'facebook_desktop'

describe FacebookDesktopApp do
  it "should load config using default config path" do
    config = FacebookDesktopApp.load_config
    config.should_not be_empty
  end
  
  it "should raise error when config path not found" do
    lambda {
      FacebookDesktopApp.load_config('whwhwoo')
    }.should raise_error
  end
  
  describe FacebookDesktopApp::Session do
    before(:each) do
      @session = FacebookDesktopApp::Session.create
    end
    
    describe "on create" do  
      it "should create session with config values on create" do  
        @session.should be_a FacebookDesktopApp::Session
      end
      
      it "should return a login_url" do
        @session.login_url.should match(/api_key=/)
        puts "Login url = " + @session.login_url
      end
    
      describe "on login" do
        it "should fail if not passed user settings" do
          lambda {
            @session.connect
          }.should raise_error ArgumentError
        end
      end
    end
  end
end