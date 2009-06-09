# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe SubscriptionNotifier do
  fixtures :all
  include SaasSpecHelper
  
  before(:each) do
    set_mailer_in_test
  end
  
  
end