require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new" do
  describe "when the user limit has been reached" do
    it_should_behave_like "a member is signed in"
    
    before(:each) do
      assigns[:user] = new_user
      @user.account.expects(:reached_user_limit?).returns(true)
      render 'users/new'
    end
    
    it "should show text explaining the limit" do
      response.should have_text(/You have reached the maximum number of users you can have with your account level./)
    end

    it "should not show the form" do
      response.should_not have_tag('form')
    end
  end
  
  describe "when the limit has not been reached" do
    it_should_behave_like "a member is signed in"
    
    before(:each) do
      assigns[:user] = new_user
      @user.account.expects(:reached_user_limit?).returns(false)
      render 'users/new'
    end
    
    it "should show the form" do
      response.should have_tag('form[action=?]', users_path)
    end
  
    it "should not show the text explaining the limit" do
      response.should_not have_text(/You have reached the maximum number of open users you can have with your account level./)
    end
  end
end