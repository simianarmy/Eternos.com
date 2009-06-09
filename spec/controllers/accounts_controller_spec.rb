require File.dirname(__FILE__) + '/../spec_helper'
include ActiveMerchant::Billing

describe AccountsController do
  fixtures :all
  #integrate_views
  include UserSpecHelper
  
  before(:each) do
    controller.stubs(:current_account).returns(@account = accounts(:localhost))
  end
  
  describe "after creating account" do
    before(:each) do
      @user = User.new(@user_params = 
        { 'login' => 'foo', 'email' => 'foo@foo.com',
          'password' => 'password', 'password_confirmation' => 'password' })
      @account = Account.new(@acct_params = 
        { 'name' => 'Bob', 'domain' => 'Bob' })
      User.expects(:new).with(@user_params).returns(@user)
      Account.expects(:new).with(@acct_params).returns(@account)
      
      @account.expects(:user=).with(@user)
      @account.expects(:save).returns(true)
      @request.env['HTTPS'] = 'on'
    end
  
    it 'with free plan should render create template' do
      @account.stubs(:needs_payment_info?).returns(false)
      post :create, :account => @acct_params, :user => @user_params, :plan => subscription_plans(:basic).name
      response.should render_template('accounts/create')
    end
    
    it 'with paying plan should render billing template' do
      @account.stubs(:needs_payment_info?).returns(true)
      post :create, :account => @acct_params, :user => @user_params, :plan => subscription_plans(:basic).name
      response.should render_template('accounts/billing')
    end
  end
  
  it "should list plans with the most expensive first" do
    @request.env['HTTPS'] = 'on'
    get :plans
    assigns(:plans).should == SubscriptionPlan.find(:all, :order => 'amount desc')
  end
  
  describe "loading the account creation page" do
    before(:each) do
      @request.env['HTTPS'] = 'on'
      @plan = subscription_plans(:basic)
      get :new, :plan => @plan.name
    end
    
    it "should load the plan by name" do
      assigns(:plan).should == @plan
    end
    
    it "should prep payment and address info" do
      assigns(:creditcard).should_not be_nil
      assigns(:address).should_not be_nil
    end
  end
  
  describe "selecting an account plan" do
    before(:each) do
      @request.env['HTTPS'] = 'on'
      @plan = subscription_plans(:basic)
      post :new, :plan => @plan.name
    end
    
    it "should display the account signup form as 1st step" do
      response.should render_template('accounts/new')
    end
  end
  
  describe 'updating an existing account' do
    it_should_behave_like "a member is signed in"
    
    it 'should prevent a non-admin from updating' do
      @user.has_no_role 'admin', @account
      @user.save!
      put :update, :account => {:user => {:first_name => 'Foo' }}
      response.should redirect_to(PERMISSION_DENIED_REDIRECTION)
    end
    
    it 'should allow an admin to update name' do
      make_user_account_admin(@user, @account)
      put :update, :account => {:user => {:first_name => 'Foo' }}
      response.should redirect_to(edit_account_url)
    end
    
    it 'should allow an admin to update login' do
      make_user_account_admin(@user, @account)
      put :update, :account => {:user => {:email => 'ass@hat.com' }}
      response.should redirect_to(edit_account_url)
    end
  end
  
  
  describe "updating billing info" do
    it_should_behave_like "a member is signed in"
    
    before(:each) do
      # controller.stubs(:current_user).returns(@account.admin)
      make_user_account_admin(@user, @account)
      @request.env['HTTPS'] = 'on'
    end
    
    it "should store the card when it and the address are valid" do
      CreditCard.stubs(:new).returns(@card = mock('CreditCard', :valid? => true, :first_name => 'Bo', :last_name => 'Peep'))
      SubscriptionAddress.stubs(:new).returns(@address = mock('SubscriptionAddress', :valid? => true, :to_activemerchant => 'foo'))
      @address.expects(:first_name=).with('Bo')
      @address.expects(:last_name=).with('Peep')
      @account.subscription.expects(:store_card).with(@card, :billing_address => 'foo', :ip => '0.0.0.0').returns(true)
      post :billing, :creditcard => {}, :address => {}      
    end
    
    describe "with paypal" do
      it "should redirect to paypal to start the process" do
        host_port = @request.host + ':' + @request.port.to_s
        @account.subscription.expects(:start_paypal).with("https://#{host_port}/account/paypal", 
          "https://#{host_port}/account/billing").returns('http://foo')
        post :billing, :paypal => 'true'
        response.should redirect_to('http://foo')
      end
      
      it "should go nowhere if the paypal token request fails" do
        @account.subscription.expects(:start_paypal).returns(nil)
        post :billing, :paypal => 'true'
        response.should render_template('accounts/billing')
      end
      
      it "should set the subscription info from the paypal response" do
        @account.subscription.expects(:complete_paypal).with('bar').returns(true)
        get :paypal, :token => 'bar'
        response.should redirect_to(billing_account_url)
      end
      
      it "should render the form when encountering problems with the paypal return" do
        @account.subscription.expects(:complete_paypal).with('bar').returns(false)
        get :paypal, :token => 'bar'
        response.should render_template('accounts/billing')
      end
    end
  end
  
  describe "when canceling" do
    it_should_behave_like "a member is signed in"
    
    before(:each) do
      # controller.stubs(:current_user).returns(@account.admin)
      make_user_account_admin(@user, @account)
      @request.env['HTTPS'] = 'on'
    end
    
    it "should not destroy the account without confirmation" do
      @account.expects(:destroy).never
      post :cancel
      response.should render_template('cancel')
    end
    
    it "should destroy the account" do
      @account.expects(:destroy).returns(true)
      post :cancel, :confirm => 1
      response.should redirect_to(canceled_account_url(:protocol => 'https'))
    end

    it "should log out the user" do
      @account.stubs(:destroy).returns(true)
      controller.expects(:current_user=).with(nil)
      post :cancel, :confirm => 1
    end
  end
end
