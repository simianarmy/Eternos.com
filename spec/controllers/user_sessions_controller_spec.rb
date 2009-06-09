# $Id$

require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  describe "on create" do
    before(:each) do
      @request.env['HTTPS'] = 'on'
    end
    
    it "should render new template on failed login" do
      UserSession.expects(:new).returns(@session = mock_model(UserSession))
      @session.stubs(:save).returns(false)
      post :create
      response.should render_template(:new)
    end
  end
end