require File.dirname(__FILE__) + '/../../spec_helper'

describe "accounts/new" do  
  fixtures :subscription_plans
  before(:each) do
    assigns[:user] = User.new
  end
    
  # Need to test 2-step functionality
  # 1. User info
  # 2. Credit card form for paid accounts
  
  describe "when plan is free" do
    before(:each) do
      assigns[:plan] = @plan = subscription_plans(:free)
      #assigns[:account] = Account.new(:plan => @plan)
      render 'accounts/new'
    end
  
    it "should include hidden field with plan value" do
      response.should have_tag("input[type=hidden][name=plan][value=?]", @plan.name)
    end
    
    it "should omit subdomain form fields" do
      template.expects(:render).with(has_entry(:partial => :subdomain_form_fields)).never
    end
    
    it "should omit billing fields" do
      response.should_not have_tag('input[name=?]', 'creditcard[first_name]')
    end
  end
end