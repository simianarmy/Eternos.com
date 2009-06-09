# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the UsersController should map" do
  controller_name :users

  specify "{ :controller => 'users', :action => 'new' } to /users/new" do
    route_for(:controller => "users", :action => "new").should == "/users/new"
  end
  
  specify "{ :controller => 'users', :action => 'activate', :activation_code => 'code'} to /activate/code" do
    route_for(:controller => "users", :action => "activate", :activation_code => "code").should == "/activate/code"
  end
end

describe UsersController do
  fixtures :all
  
  before(:each) do
    controller.stubs(:current_account).returns(@account = accounts(:localhost))
    @user = @account.users.first
  end
  
  describe "with normal users" do
    it_should_behave_like "a member is signed in"
    
    # it "should allow viewing the index" do
    #       @account.users.stubs(:find).returns([])
    #       get :index
    #       response.should render_template('index')
    #       assigns(:users).should == []
    #     end
    
    it "should prevent adding new users" do
      get :new
      response.should redirect_to(PERMISSION_DENIED_REDIRECTION)
    end
    
    it "should prevent creating users" do
      post :create, :user => { :name => 'bob' }
      response.should redirect_to(PERMISSION_DENIED_REDIRECTION)
    end
    
    # it "should prevent editing users" do
    #       get :edit, :id => @user.id
    #       response.should redirect_to(new_session_url)
    #     end
    #     
    #     it "should prevent updating users" do
    #       put :update, :id => @user.id, :user => { :name => 'bob' }
    #       response.should redirect_to(new_session_url)
    #     end
  end
  
  # describe "with admin users" do
  #     include UserSpecHelper
  #     it_should_behave_like "a member is signed in"
  #     
  #     before(:each) do
  #       make_user_account_admin(@user, @account)
  #       @account.stubs(:reached_user_limit?).returns(false)
  #     end
  # 
  #     it "should allow viewing the index" do
  #       @account.users.stubs(:find).returns([])
  #       get :index
  #       response.should render_template('index')
  #       assigns(:users).should == []
  #     end
  # 
  #     it "should allow adding users" do
  #       @account.users.expects(:build).returns(@user = User.new)
  #       get :new
  #       assigns(:user).should == @user
  #       response.should render_template('new')
  #     end
  # 
  #     it "should allow creating users" do
  #       @account.users.expects(:build).with(valid_user.stringify_keys).returns(@user = User.new)
  #       @user.expects(:save).returns(true)
  #       post :create, :user => valid_user
  #       response.should redirect_to(users_url)
  #     end
  #     
  #     it "should allow editing users" do
  #       get :edit, :id => @user.id
  #       assigns(:user).should == @user
  #       response.should render_template('edit')
  #     end
  #     
  #     it "should allow updating users" do
  #       @account.users.expects(:find).with(@user.id.to_s).returns(@user)
  #       @user.expects(:update_attributes).with(valid_user.stringify_keys).returns(true)
  #       put :update, :id => @user.id, :user => valid_user
  #       response.should redirect_to(users_url)
  #     end
  #     
  #     it "should prevent creating users when the user limit has been reached" do
  #       @account.expects(:reached_user_limit?).returns(true)
  #       @account.users.expects(:build).returns(@user = User.new)
  #       @user.expects(:save).never
  #       post :create, :user => valid_user
  #       response.should redirect_to(new_user_url)
  #     end
  #   end
end

describe UsersController, "on signup" do
  include UserSpecHelper
  
  specify "should be an UsersController" do
    controller.should be_an_instance_of( UsersController)
  end
  
  specify "should display activation status page" do
    lambda {
      signup :email => 'fooboo@shoo.com'
      response.should render_template('create')
      assigns(:user).email.should == 'fooboo@shoo.com'
    }.should change(User,:count).by(1)
  end

  #specify "should require login on signup" do
  #  create_user :login => nil 
  #  response.should be_success
  #  assigns(:user).should have_at_least(1).errors_on(:login)
  #  assigns(:user).errors.on(:login).should equal("")
  #end

  specify "should require password on signup" do
    signup :password => nil
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:password)
  end

  specify "should require password confirmation on signup" do
    signup :password_confirmation => nil 
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:password_confirmation)
  end

  specify "should require email on signup" do
    signup :email => nil 
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:email)
  end
  
  specify "should fall back to new if save failed" do
    post :create, :user => {}
    response.should render_template('new')
    assigns(:user).should have_at_least(1).errors
  end
  
  specify "should not be a member until activated" do
    signup
    assigns(:user).should_not be_member
  end

  it "should email signup notification on successful signup" do
    UserMailer.expects(:deliver_signup_notification)
    signup
  end
  
  protected

  def signup(options = {})
    post :create, :user => valid_user_attributes_with_password.symbolize_keys.merge(options)
  end
end

describe "The Users controller on activate" do
  controller_name :users
  
  before(:each) do
    @user = mock_model(User)
  end

  it "should enable unactivated user with valid activation code" do
    User.stubs(:find_by_activation_code).returns(@user)
    @user.stubs(:role).returns('Member')
    
    @user.expects(:active?).returns(false)
    @user.expects(:activate!).returns(true)

    get :activate, :activation_code => 'correct_activation_code'
    response.should render_template('activate')
  end
  
  specify "should not enable activated user with valid activation code" do
    User.stubs(:find_by_activation_code).returns(@user)
    
    @user.expects(:active?).returns(true)
    @user.expects(:activate!).never

    get :activate, :activation_code => 'correct_activation_code'
    response.should redirect_to('http://test.host/')
  end
  
  specify "should not enable user with invalid activation code" do
    User.stubs(:find_by_activation_code).returns(nil)
    
    get :activate, :activation_code => 'invalid_activation_code'
    response.should redirect_to('http://test.host/')
    flash[:notice].should_not be_empty
  end
end
