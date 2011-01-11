require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Vault::AccountsController do
  ActionController::Integration::Session
  
  describe "on new" do
    it "should check the terms and conditions checkbox" do
      get :new
      assigns[:terms_accepted].should be_true
    end
  end
  
  describe "on create" do
    fixtures :subscriptions, :subscription_plans
    def required_params
      {:user => {:email => Faker::Internet.email, 
        :password => @pwd = Faker::Lorem.words(3).join(''),
        :password_confirmation => @pwd,
        :full_name => Faker::Name.name,
        },
        :account => {:company_name => Faker::Company.name,
          :phone_number => Faker::PhoneNumber.phone_number}
      }
    end
    
    def post_info
      post :create, @params.merge!(required_params)
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
      before(:each) do
        controller.stubs(:verify_recaptcha).returns(true)
      end
      
      describe "with terms of service not accepted" do
        before(:each) do 
          @params = {:plan => 'Free'}
        end
        
        # Weird that this should fail..oh well.
        it "should not create an account even when required params filled" do
          post_info
          response.should render_template(:new)
        end
      end
      
      describe "with terms of service accepted" do
        before(:each) do 
          @params = {:plan => 'Free', :user => {:terms_of_service => true}}
        end
      
        it "should create an account" do
          lambda {
            post_info
          }.should change(Account, :count).by(1)
        end
      
        it "should save form values to account records" do
          post_info
          assigns[:account].name.should == @params[:user][:full_name]
          assigns[:account].user.login.should == @params[:user][:email]
          assigns[:account].user.email.should == @params[:user][:email]
          assigns[:account].company_name.should == @params[:account][:company_name]
          assigns[:account].phone_number.should == @params[:account][:phone_number]
        end
      
        it "should render the create page" do
          post_info
          response.should render_template(:create)
        end
        
        it "should assign member role to the user" do
          post_info
          assigns[:user].should be_member
        end
      end
    end
      
    describe "without valid captcha" do
      before(:each) do 
        controller.stubs(:verify_recaptcha).returns(false)
        @params = {:plan => 'Free', :user => {:terms_of_service => true}}
      end
      
      it "should not create an account even when required params filled" do
        post_info
        response.should render_template(:new)
      end
    end
  end
  
  describe "choosing an account plan" do
    before(:each) do
      @params = {:plan => 'Free', :user => {:terms_of_service => true}}
      controller.stubs(:verify_recaptcha).returns(true)
      post_info
    end
    
    
  end
end
