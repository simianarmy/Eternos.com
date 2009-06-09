# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController do
  fixtures :all
  integrate_views
 
  it_should_behave_like "a member is signed in"
  before(:each) do
    @email = 'ass@grass.com'
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template" do
    post :create
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Invitation.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should display flash notice when model is invalid" do
    post :create
    assigns[:invitation].errors.should_not be_empty
  end
  
  it "create action should display flash notice when existing email entered" do
    create_invitation @member.email
    assigns[:invitation].should have(1).error_on(:recipient_email)
  end
  
  it "create action should display success on successful invitation" do
    create_invitation
    flash[:notice].should == "Invitation sent."
    response.should redirect_to(new_invitation_path)
  end
  
  it "create action should send invitation email" do
    UserMailer.expects(:deliver_invitation)
    create_invitation
  end
  
  it "create action should send decrement invitation count" do
    lambda {
      create_invitation 
    }.should change(@user, :invitation_limit).by(-1)
  end
  
  def create_invitation(email=@email)
    post :create, :invitation => {:recipient_email => email}
  end
end
