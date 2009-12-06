# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe SubscriptionNotifier do
  fixtures :subscription_plans, :subscriptions
  include SaasSpecHelper
  
  before(:each) do
    set_mailer_in_test
  end
  
  
end