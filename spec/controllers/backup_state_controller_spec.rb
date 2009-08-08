# $Id$ 

require File.dirname(__FILE__) + '/../spec_helper'

describe BackupStateController do
  it_should_behave_like "a member is signed in"
  
  describe "GET show.js" do
    it "should return need_setup => true if account not setup" do
      xhr :get, :show
      response.should be_success
      puts response.body
      #ActiveSupport::JSON.decode(response.body)['need_setup'].should be_true
    end
  end
end