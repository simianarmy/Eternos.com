# $Id$

require File.dirname(__FILE__) + '/../../spec_helper'

describe "accounts/billing" do
  fixtures :subscriptions, :subscription_plans
  before(:each) do
    assigns[:user] = mock_model(User)
    assigns[:plan] = @plan = subscription_plans(:basic)
    assigns[:creditcard] = @card = ActiveMerchant::Billing::CreditCard.new
    assigns[:address] = @address = SubscriptionAddress.new
    assigns[:account] = @account = mock_model(Account, :login? => true)
    session[:account_id] = @account.id
  end
  
  describe "when plan is paid" do
    describe "with trials enabled" do
      before(:each) do
        assigns[:subscription] = subscriptions(:one)
      end
      
      it "should include the credit card form when payment info required" do
        AppConfig['require_payment_info_for_trials'] = true
        @account.stubs(:needs_payment_info?).returns(true)
        render 'accounts/billing'
        response.should have_tag('input[name=?]', 'creditcard[first_name]')
      end
    
      it "should omit the credit card form without payment info required up-front" do
        AppConfig['require_payment_info_for_trials'] = false
        @account.stubs(:needs_payment_info?).returns(false)
        render 'accounts/billing'
        response.should_not have_tag('input[name=?]', 'creditcard[first_name]')
      end
    end
  end
end