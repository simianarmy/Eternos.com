# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

module InvitationSpecHelper
  def valid_attributes
    {:sender_id => 1, :recipient_email => 'ass@grass.com'}
  end
end

describe Invitation do
  include InvitationSpecHelper
  
  before(:each) do
    @invitation = Invitation.new
  end
  
  it "should not be valid without required attributes" do
    @invitation.should_not be_valid
    @invitation.attributes = valid_attributes
    @invitation.should be_valid
  end
end

describe Invitation, "on create" do
  include InvitationSpecHelper
  
  before(:each) do
    @invitation = Invitation.new
  end
  
  it "should not be valid with registered user's email address" do
    email = create_user.email
    @invitation.attributes = valid_attributes.merge(:recipient_email => email)
    @invitation.should_not be_valid
    @invitation.should have(1).error_on(:recipient_email)
  end
end
