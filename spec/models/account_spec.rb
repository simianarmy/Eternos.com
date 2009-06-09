require File.dirname(__FILE__) + '/../spec_helper'
include ActiveMerchant::Billing

describe Account do
  fixtures :all
  include SaasSpecHelper
  before(:each) do
    @account = accounts(:localhost)
    @plan = subscription_plans(:basic)
    AppConfig['require_payment_info_for_trials'] = true
  end
  
  it 'should be invalid with an missing user' do
    @account = Account.new(:domain => 'foo')
    @account.should_not be_valid
    @account.errors.full_messages.should include("Missing user information")
  end
  
  it 'should be invalid with an invalid user' do
    @account = Account.new(:domain => 'foo', :user => User.new)
    @account.should_not be_valid
    @account.errors.full_messages.should_not be_empty
  end
  
  it "should set the full domain when created" do
    @account = Account.create(:domain => 'foo', :user => User.new(valid_user), :plan => subscription_plans(:free))
    @account.full_domain.should == "foo.#{AppConfig['base_domain']}"
  end
  
  it "should require payment info when being created with a paid plan when the app configuration requires it" do
    @account = Account.new(:domain => 'foo', :user => User.new(valid_user), :plan => @plan)
    @account.needs_payment_info?.should be_true
  end
  
  it "should not require payment info when being created with a paid plan when the app configuration does not require it" do
    AppConfig['require_payment_info_for_trials'] = false
    @account = Account.new(:domain => 'foo', :user => User.new(valid_user), :plan => @plan)
    @account.needs_payment_info?.should be_false
  end
  
  it "should not require payment info when being created with free plan" do
    @account = Account.new(:domain => 'foo', :user => User.new(valid_user), :plan => subscription_plans(:free))
    @account.needs_payment_info?.should be_false
  end
  
  it "should require payment info when created with a paid plan" do
    @account = Account.create(:domain => 'foo', :user => User.new(valid_user), :plan => @plan)
    @account.should_not be_valid
  end
  
  it "should be invalid without valid payment and address info with a paid plan if in paying state" do
    @account = Account.create(:domain => 'foo', :user => User.new(valid_user), :plan => @plan)
    @account.billing_update!
    @account.should_not be_valid
    @account.errors.full_messages.should include("Invalid payment information")
    @account.errors.full_messages.should include("Invalid address")
  end

  it "should create the user when created" do
    lambda {
      @account = Account.create(:domain => 'foo', :user => User.new(valid_user), :plan => subscription_plans(:free))
    }.should change(User, :count).by(1)
  end
  
  it "should respond to users" do
    @account = Account.create(:domain => 'foo', :user => @user = User.new(valid_user), :plan => subscription_plans(:free))
    @account.users.first.should be_eql(@user)
  end
  
  it "should create the subscription when created" do
    lambda do
      @account = Account.create(:domain => 'foo', :user => User.new(valid_user), :plan => subscription_plans(:free))
    end.should change(Subscription, :count)
    Subscription.find(:first, :order => 'id desc').account.should == @account
  end
  
  it "should have one admin user when created" do
    @account = Account.create(:domain => 'foo', :user => @user = User.new(valid_user), :plan => subscription_plans(:free))
    @user.account.should == @account
    @user.is_admin_of_what.should include(@account)
  end
  
  it "should delegate needs_payment_info? to subscription for existing accounts" do
    @account.subscription.expects(:needs_payment_info?)
    @account.needs_payment_info?
  end
  
  it "should indicate the user limit has been reached when the number of active positions equals the user limit" do
    @account.users.stubs(:count).returns(@account.subscription.user_limit)
    @account.reached_user_limit?.should be_true
  end
  
  it "should not indicate the user limit has been reached when the number of active positions is less than the user limit" do
    @account.users.stubs(:count).returns(@account.subscription.user_limit - 1)
    @account.reached_user_limit?.should_not be_true
  end
  
  it "should not indicate the user limit has been reached when the account has no user limit" do
    @account.subscription.user_limit = nil
    @account.users.stubs(:count).returns(1)
    @account.reached_user_limit?.should_not be_true
  end
  
  describe "validating domains" do
    before(:each) do
      @account = Account.new
    end
    
    describe "for plans without subdomains" do
      it "should not prevent blank domains" do
        @account.domain = ''
        @account.should_not be_valid
        @account.should have(0).errors_on(:domain)
      end
    end
    
    describe "for plans with subdomains" do
      before(:each) do
        @account.plan = subscription_plans(:advanced)
      end
      
      it "should prevent duplicate domains if domains enabled" do
        @account.domain = 'foo'
        Account.expects(:count).with(:conditions => ['full_domain = ?', "foo.#{AppConfig['base_domain']}"]).returns(1)
        @account.should_not be_valid
        @account.errors.on(:domain).should == 'is not available'
      end
    
      it "should prevent bad domain formats" do
        %w(foo.bar foo_bar foo-bar).each do |name|
          @account.domain = name
          @account.should_not be_valid
          @account.errors.on(:domain).should == 'is an invalid format'
        end
      end
    
      it "should not allow the uniqueness check to interfere with updating an account" do
        @account = accounts(:localhost)
        @account.plan = subscription_plans(:advanced)
        Account.expects(:count).with(:conditions => ['full_domain = ? and id <> ?', @account.full_domain, @account.id]).returns(0)
        @account.name = 'Blah'
        @account.state = 'paying'
        @account.should be_valid
      end
    end
  end
  
  describe "when being created with payment info" do
    before(:each) do
      @account = Account.new(:domain => 'foo', :user => User.new(valid_user), :plan => @plan, :creditcard => @card = CreditCard.new(valid_card), :address => @address = SubscriptionAddress.new(valid_address))
      @account.expects(:build_subscription).with(:plan => @plan, :next_renewal_at => nil, :creditcard => @card, :address => @address).at_least(1).returns(@account.subscription = @subscription = Subscription.new(:plan => @plan, :creditcard => @card, :address => @address))
      @subscription.stubs(:gateway).returns(@gw = BogusGateway.new)
      
      #SubscriptionNotifier.stubs(:deliver_welcome).returns(true)
    end
    
    it "should store the CC info with BrainTree and create the account" do
      lambda do
        @account.save.should be_true
      end.should change(Account, :count).by(1)
      Account.find(:first, :order => 'id desc').should == @account
    end
    
    it "should create the subscription" do
      lambda do
        @account.save.should be_true
      end.should change(Subscription, :count)
      Subscription.find(:first, :order => 'id desc').account.should == @account
    end
    
    it "should report errors when failing to store the CC info with BrainTree" do
      @subscription.expects(:valid?).returns(false)
      @subscription.errors.expects(:full_messages).returns(["Forced failure"])
      lambda do
         @account.save.should be_false
      end.should_not change(Account, :count)
      @account.errors.full_messages.should == ["Error with payment: Forced failure"]
    end
  
    it "should log the initial billing, if needed" do
      @gw.stubs(:purchase).returns(BogusResponse.new(true, 'Success'))
      @plan.update_attribute(:trial_period, nil)
      lambda do
        @account.save.should be_true
      end.should change(SubscriptionPayment, :count)
      (@sp = SubscriptionPayment.find(:first, :order => 'id desc')).account.should == @account
      @sp.subscription.should == @account.subscription
    end
  end
  
  describe "when checking for a qualifying subscription plan" do
    before(:each) do
      @plan = subscription_plans(:basic)
    end

    describe "against the user limit" do
      before(:each) do
        @plan.user_limit = 3
      end

      it "should qualify if the plan has no user limit" do
        @plan.user_limit = nil
        @account.users.expects(:count).never
        @account.qualifies_for?(@plan).should be_true
      end
    
      it "should qualify if the plan has a user limit greater than or equal to the number of users" do
        @account.users.expects(:count).returns(@plan.user_limit - 1)
        @account.qualifies_for?(@plan).should be_true
        @account.users.expects(:count).returns(@plan.user_limit)
        @account.qualifies_for?(@plan).should be_true
      end
    
      it "should not qualify if the plan has a user limit less than the number of users" do
        @account.users.expects(:count).returns(@plan.user_limit + 1)
        @account.qualifies_for?(@plan).should be_false
      end
    end
    
  end
  
  describe "when cancelling" do
    it "should move the account to the deleted accounts table" do
      # will run the model through a destroy and undestroy while making sure all values were saved
      lambda {
        @account.destroy
      }.should change(Account, :count).by(-1) && change(Account::Deleted, :count).by(1)
    end
  end
end