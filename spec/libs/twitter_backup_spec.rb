# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

require 'twitter_backup'

describe TwitterBackup do
  before(:each) do
    @valid_user = 'eternostest'
    @valid_pass = 'w7TpXpO8qAYAUW'
    @valid_token = '54721863-mIVXY8WyLLokR8knYMm27Hdq9ZBjnnRB20VuFscFo'
    @valid_secret = '3KjSKT7x5RzR1p7B7dnjnzyQs3PKJAAPqb3lH5KBk'
  end

  it "should return the twitter oauth app config keys" do
    config = TwitterBackup.load_config
    config['consumer_key'].should_not be_blank
  end

  describe Twitter do
    def validate_user_timeline(client)
      items = client.user_timeline
      puts "timeline size = " + items.size.to_s
      items.all? {|item| item.id > 0 && item.text.any? }.should be_true
    end
    
    describe "with valid http auth credentials" do
      before(:each) do
        @client = TwitterBackup::Twitter.http_client(@valid_user, @valid_pass)
      end
      
      it "should return a client object with user's credentials" do
        @client.should be_a Twitter::Base
        @client.verify_credentials.id.should > 0
      end
      
      it "client should return a user tweet timeline" do
        validate_user_timeline(@client)
      end
    end
    
    describe "with valid OAuth credentials" do
      before(:each) do 
        @client = TwitterBackup::Twitter.oauth_client(@valid_token, @valid_secret)
      end
      
      it "should return a client object with user's credentials" do
        @client.should be_a Twitter::Base
        @client.verify_credentials.id.should > 0
      end
      
      it "client should return a user tweet timeline" do
        validate_user_timeline(@client)
      end
    end
  end
end

    