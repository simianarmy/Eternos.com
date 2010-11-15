# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  include UserSpecHelper
  
  describe "on create" do
    before(:each) do
      @request.env['HTTPS'] = 'on'
    end
    
    it "should render new template on failed login" do
      UserSession.any_instance.expects(:save).returns(false)
      post :create
      response.should render_template(:new)
    end
    
    it "should strip whitespace from credential inputs" do
      @user = make_member(valid_user_attributes_with_password)
      post :create, :user_session => {:login => @user.login + ' ', :password => " fuckthisshit "}
      response.should redirect_to account_setup_url
    end
  end
end