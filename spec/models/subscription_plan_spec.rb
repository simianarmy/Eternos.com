require File.dirname(__FILE__) + '/../spec_helper'
include ActionView::Helpers::NumberHelper

describe SubscriptionPlan do
  fixtures :subscription_plans
  include SaasSpecHelper
  
  before(:each) do
    @plan = subscription_plans(:basic)
  end

  it "should return a formatted name" do
    @plan.to_s.should == "#{@plan.name} - #{number_to_currency(@plan.amount)} / month"
  end
  
  it "should return the name for URL params" do
    @plan.to_param.should == @plan.name
  end
end
