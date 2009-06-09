require File.dirname(__FILE__) + '/../../spec_helper'

describe "/accounts/edit" do
  fixtures :accounts
  before(:each) do
    assigns[:account] = @account = accounts(:localhost)
  end
end
