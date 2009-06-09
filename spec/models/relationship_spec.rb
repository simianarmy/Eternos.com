# $Id$
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Relationship do
  include GuestSpecHelper
  
  before(:each) do 
    @member = create_member
  end
  
  it "adding guest to member should create a relationship" do
     lambda {
       create_guest_with_host(@member)
     }.should change(Relationship, :count).by(1)
  end
  
  it "dropping guest from relationship should destroy relationship" do
    @guest = create_guest_with_host(@member)
    lambda {
      @member.remove_guest @guest
    }.should change(Relationship, :count).by(-1)
  end
end

