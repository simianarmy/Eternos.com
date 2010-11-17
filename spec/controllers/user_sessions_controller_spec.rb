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
  
  # TODO: 
  # Cuke this process
  describe "on coreg user" do
    before(:each) do
      @request.env['HTTPS'] = 'on'
      @user = make_member(valid_user_attributes_with_password)
      @user.password = @user.password_confirmation = User::COREG_PASSWORD_PLACEHOLDER
      @user.save!
    end
    
    it "should have coreg user password" do
      @user.should be_using_coreg_password
    end
    
    it "should display choose password page on get" do
      get :choose_password
      assigns[:user_session].should_not be_nil
    end
    
    it "should save new password if login matches coreg user" do
      passwd = 'foobar1'
      post :save_password, :user_session => {:login => @user.login, :password => passwd}, 
        :password_confirmation => passwd
      response.should redirect_to account_setup_url
      assigns[:user].password.should == passwd
    end
    
    it "should fail if login not a coreg user" do
      normal_user = make_member(valid_user_attributes_with_password)
      passwd = 'foobar1'
      post :save_password, :user_session => {:login => normal_user.login, :password => passwd}, 
        :password_confirmation => passwd
      response.should render_template(:choose_password)
      flash[:error].should_not be_empty
    end
    
    it "should fail with blank passwords" do
      post :save_password, :user_session => {:login => @user.login, :password => ''}, 
        :password_confirmation => ''
      response.should render_template(:choose_password)
      flash[:error].should_not be_empty
    end
    
    it "should fail if passwords don't match" do
      passwd = 'foobar1'
      post :save_password, :user_session => {:login => @user.login, :password => passwd}, 
        :password_confirmation => 'foobar2'
      response.should render_template(:choose_password)
      flash[:error].should_not be_empty
    end
    
    it "should fail if either password is empty" do
      passwd = 'foobar1'
      post :save_password, :user_session => {:login => @user.login, :password => passwd}, 
        :password_confirmation => ''
      response.should render_template(:choose_password)
      flash[:error].should_not be_empty
      
      post :save_password, :user_session => {:login => @user.login, :password => ''}, 
        :password_confirmation => passwd
      response.should render_template(:choose_password)
      flash[:error].should_not be_empty
    end
  end
end