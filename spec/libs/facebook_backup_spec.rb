# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

require 'facebook_backup'

describe FacebookBackup do
  it "should load config using default config path" do
    config = FacebookBackup.load_config
    config.should_not be_empty
    config['api_key'].should_not be_blank
  end

  it "should raise error when config path not found" do
    lambda {
      FacebookBackup.load_config('whwhwoo')
      }.should raise_error
  end

  describe FacebookBackup::Session do
    it "should load passed config file on create" do
      @session = FacebookBackup::Session.create(File.join(RAILS_ROOT, 'config', 'facebooker_desktop.yml'))
      Facebooker::Session.api_key.should_not be_blank
    end

    describe "on create" do  
      before(:each) do
        @session = FacebookBackup::Session.create
      end

      it "should create session with config values on create" do  
        @session.should be_a FacebookBackup::Session
      end

      it "should return a login_url" do
        @session.login_url.should match(/api_key=/)
        puts "Login url = " + @session.login_url
      end
    end

    describe "on login" do
      before(:each) do
        @session = FacebookBackup::Session.create
      end

      it "should fail if not passed user settings" do
        lambda {
          @session.connect
        }.should raise_error ArgumentError
      end
    end

    describe "on verify" do
      before(:each) do
        @session = FacebookBackup::Session.create
      end

      it "should not raise errors on failure" do
        @session.connect('wrong', 0, 0, 'wrong')
        lambda {
          @session.verify_permissions
        }.should_not raise_error
      end
      
      it "should save cause of failure" do
        @session.connect('wrong', 0, 0, 'wrong')
        @session.verify_permissions
        @session.errors.should_not be_blank
      end
    end
  end
end