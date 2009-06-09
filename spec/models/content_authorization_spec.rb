# $Id$
# Test acts_as_restricted plugin integration
require File.dirname(__FILE__) + '/../spec_helper'

module ContentAuthorizationSpecHelper
  def match_auth(auth, obj, user, group)
    auth.content_authorization.authorizable_id.should == obj.id
    auth.content_authorization.authorizable_type.should == obj.class.to_s
    auth.user_id.should == (user ? user.id : 0)
    auth.circle_id.should == (group ? group.id : 0)
    auth.permissions.should be_an_instance_of Permissions
  end
end
  
describe ContentAuthorization, "a restricted object" do
  include ContentAuthorizationSpecHelper
  include GuestSpecHelper
  
  before(:each) do
    @object = create_story
    @owner = @object.get_owner
    @guest = create_guest_with_host(@owner)
  end
  
  it "should not be accessible if not saved" do
    @object = Story.new
    @object.is_authorized_for?(@guest).should be_false
  end
  
  it "should not create privacy settings when accessing 1st time" do
    lambda {
      @object.authorization
    }.should_not change(ContentAuthorization, :count)
  end
  
  it "should build privacy settings on access" do
    @object.get_privacy_setting.should be_an_instance_of(ContentAuthorization)
  end
  
  it "should allow anyone after authorizing for all" do
    @object.authorize_for_all
    @object.authorization.should == ContentAuthorization::AuthPublic
    @object.authorizations.should be_empty
    @object.is_authorized_for?(nil).should be_true
  end
  
  describe "authorized for all guests" do
    before(:each) do
      @object.authorize_for_all_guests
    end
    
    it "should have proper authorization value" do
      @object.authorization.should == ContentAuthorization::AuthPrivate
      @object.authorizations.should be_empty
    end
    
    it "should allow a member's guest" do
      @object.is_authorized_for?(@guest).should be_true
    end
  
    it "show not allow based on circle only" do
      @object.is_authorized_for?(nil, @guest.circle).should_not be_true
    end
    
    it "should not allow a guest if guest removed from member" do
      @guest.is_not_guest_of @owner
      @object.is_authorized_for?(@guest).should be_false
    end
  end

  it "should allow no guests after authorizing for private use" do
    @object.authorize_for_none
    @object.authorization.should == ContentAuthorization::AuthInvisible
    @object.authorizations.should be_empty
    @object.is_authorized_for?(@guest).should be_false
    @object.is_authorized_for?(nil, @guest.circle).should be_false
  end
  
  describe "with guests" do
    it "should add same accessor to database only once" do
      lambda {
        2.times { @object.authorize_for_user(@guest) }
      }.should change(ContentAccessor, :count).by(1)
    end
  
    it "should not be authorized for anyone but guests added" do
      other_guest = create_guest_with_host(@owner)
      @object.authorize_for_user(@guest)
      @guest.should_not be_eql(other_guest)
      @object.is_authorized_for?(@guest).should be_true
      @object.is_authorized_for?(other_guest).should be_false
    end
  
    it "should empty authorizations when setting level to private" do
      @object.authorize_for_user(@guest)
      @object.authorizations.should_not be_empty
      @object.authorize_for_none
      @object.authorizations.should be_empty
    end
  end

  describe "with guest and circle specified" do 
    before(:each) do
      @circle = create_circle
    end
  
    it "should add same accessor to database once" do
       lambda {
         2.times { @object.authorize_for_user(@guest, @circle) }
       }.should change(ContentAccessor, :count).by(1)
    end
  
    it "should match authorized attributes after authorizing for user and group" do
      @object.authorize_for_user(@guest, @circle)
      @auth = @object.authorizations.first
      match_auth(@auth, @object, @guest, @circle)
    end
  
    it "should be authorized for a guest (with circle) if guest+circle added to authorizations" do
      @object.authorize_for_user(@guest, @circle)
      @object.is_authorized_for(@guest, @circle).should_not be_empty
      @object.is_authorized_for(@guest, @circle).first.user.should be_eql(@guest)
      @object.is_authorized_for?(@guest).should be_false
      @object.is_authorized_for?(@guest, @circle).should be_true
    end
  end

  describe "with only circle specified" do
    before(:each) do
      @circle = create_circle(:user_id => @owner.id)
    end

    it "should be added to database" do
      lambda {
        @object.authorize_for_group(@circle)
      }.should change(ContentAuthorization, :count).by(1)
    end
  
    it "should match authorized attributes after authorizing for group only" do
      @object.authorize_for_group(@circle)
      @auth = @object.authorizations.first
      match_auth(@auth, @object, nil, @circle)
    end
  
    it "should not be authorized to anyone not in authorized circle" do
       @object.authorize_for_group(@circle)
       @guest = create_guest_with_host(@owner, :circle => @circle)
       @other_circle = create_circle(:name => 'other')
       @object.is_authorized_for?(@guest).should be_false
       @object.is_authorized_for?(@guest, @other_circle).should be_false
      @object.is_authorized_for?(nil, @other_circle).should be_false
       @object.is_authorized_for?(nil, @circle).should be_true
       @object.is_authorized_for?(@guest, @circle).should be_true
     end
   end
end
