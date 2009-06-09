# $Id$

require File.dirname(__FILE__) + '/../../spec_helper'

describe "member_home" do

  describe "when user logged in" do
    it_should_behave_like "a member is signed in"
    
    before(:each) do
      assigns[:user] = @user
    end
    
    it "should render the members layout" do
      render 'member_home/index', :layout => "member"
    end
  end
end