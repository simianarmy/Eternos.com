require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Vault::Accounts::RegistrationController do
  ActionController::Integration::Session
  
  fixtures :subscriptions, :subscription_plans, :countries
  
  before(:each) do
    @request.env['HTTPS'] = 'on'
  end
  
  describe "on new" do
    it "should load default instances" do
      get :new
      assigns[:account].should be_a Account
      assigns[:user].should be_a User
      assigns[:terms_of_service].should be_true
      session[:account_id].should be_nil
      session[:invitation_token].should be_nil
    end
  end
  
  describe "on create" do 
    # TODO: USE FORMTASTIC HELPER TO GENERATE PARAMS
    def required_params
      {:account => {:company_name => Faker::Company.name,
          :phone_number => Faker::PhoneNumber.phone_number,
          :users_attributes => {'0' => {:email => Faker::Internet.email, 
            :password => @pwd = Faker::Lorem.words(3).join(''),
            :password_confirmation => @pwd,
            :full_name => Faker::Name.name,
            :terms_of_service => '1'}}}
      }
    end
    
    def post_info(opts=required_params)
      post :create, @params.merge!(opts)
    end
    
    describe "without required parameters" do
      before(:each) do 
        @params = {:plan => 'Free'}
        controller.stubs(:verify_recaptcha).returns(true)
      end
      
      it "should display the signup form with errors unless all required parameters are entered" do
        post :create, {}
        response.should render_template(:new)
        assigns[:user].errors.should_not be_empty
        params = @params.merge(required_params)
        params[:account][:phone_number] = nil
        post :create, @params
        response.should render_template(:new)
        assigns[:account].errors.should_not be_empty
      end
    end
    
    describe "with required parameters" do  
      describe "with terms of service not accepted" do
        before(:each) do 
          @params = {:plan => 'Free'}
        end
        
        # Weird that this should fail..oh well.
        it "should not create an account even when required params filled" do
          req = required_params
          req[:account][:users_attributes]['0'][:terms_of_service] = '0'
          post_info req
          response.should render_template(:new)
        end
      end
      
      describe "with terms of service accepted" do
        before(:each) do 
          @params = {:plan => 'Free'}
        end
      
        it "should create an account" do
          lambda {
            post_info
          }.should change(Account, :count).by(1)
        end
      
        it "should save form values to account records" do
          params = required_params
          post_info params
          assigns[:account].name.should == params[:account][:users_attributes]['0'][:full_name]
          assigns[:account].user.login.should == params[:account][:users_attributes]['0'][:email]
          assigns[:account].user.email.should == params[:account][:users_attributes]['0'][:email]
          assigns[:account].company_name.should == params[:account][:company_name]
          assigns[:account].phone_number.should == params[:account][:phone_number]
        end
      
        it "should redirect to the plans page" do
          post_info
          response.should redirect_to(plans_account_registration_url)
        end
        
        it "should assign member role to the user" do
          post_info
          assigns[:user].should be_member
        end
      end
    end
  end
  
  describe "on subscription plans" do
    it "should redirect to the login url if no account id in the session" do
      get :plans
      # subdomain_fu prevents using routes - it prefixes 'www' to domain
      response.should redirect_to('https://test.host:80/vlogin')
    end
    
    it "should load an account from the session" do
      @account = create_account
      session[:account_id] = @account.id
      get :plans
      response.should render_template(:plans)
    end
    
    it "should load the plans into an instance array" do
      @account = create_account
      session[:account_id] = @account.id
      get :plans
      assigns[:plans].first.should be_a SubscriptionPlan
    end
  end
  
  describe "choosing plan" do
    before(:each) do
      @account = create_account
      session[:account_id] = @account.id
    end
    
    describe "with no payment required" do
      it "should redirect to account setup" do
        post :choose_plan 
        # subdomain_fu prevents using routes - it prefixes 'www' to domain
        response.should redirect_to('https://test.host:80/account_setup') 
      end
    end
    
    describe "with payment required" do
      it "should render the billing view" do
        post :choose_plan, :plan => 'Advanced'
        response.should render_template("billing")
      end
      
      it "should save the account id in the session" do
        post :choose_plan, :plan => 'Advanced'
        session[:account_id].should == @account.id
      end
      
      it "should save the new plan if different than the default" do
        post :choose_plan, :plan => 'Advanced'
        assigns[:subscription].subscription_plan.name.should == 'Advanced'
        @account.reload.subscription.should == assigns[:subscription]
      end
      
      it "should load the chosen plan for display in the billing template" do
        post :choose_plan, :plan => 'Advanced'
        assigns[:plan].name.should == 'Advanced'
      end
    end
  end
  
  describe "saving billing information" do
    before(:each) do
      @account = create_account
      session[:account_id] = @account.id
      post :choose_plan, :plan => 'Advanced'
    end
    
    it "should should not do anything unless request is put or post" do
      get :billing
      response.should render_template(:billing)
    end
    
    it "should initialize activemerchant billing objects" do
      get :billing
      assigns[:creditcard].should_not be_nil
      assigns[:subscription_address].should_not be_nil
    end
    
    it "should display errors without required fields" do
      post :billing
      assigns[:creditcard].should_not be_valid
      assigns[:subscription_address].should_not be_valid
    end
    
    describe "on success" do
      before(:each) do
        ActiveMerchant::Billing::CreditCard.stubs(:new).returns(@cc = mock('ActiveMerchant::Billing::CreditCard'))
        SubscriptionAddress.stubs(:new).returns(@addr = mock('SubscriptionAddress'))
        @cc.stubs(:valid? => true, :first_name => 'dr', :last_name => 'no')
        @addr.stubs(:valid? => true, :country => stub("Country", :id => 1, :name => "US"), :to_activemerchant => "")
        @addr.expects(:first_name=).with('dr')
        @addr.expects(:last_name=).with('no')
        Subscription.any_instance.stubs(:store_card).returns(true)
      end
      
      it "should render thanks template" do
        post :billing
        response.should render_template(:thanks)
      end
      
      it "should send an activation email" do
        controller.expects(:send_activation_mail)
        post :billing
      end
      
      it "should log the user in" do
        UserSession.expects(:create).with(@account.admin, true)
        post :billing
      end
    end
  end
end
