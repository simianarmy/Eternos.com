require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GuestInvitationsController do
  it_should_behave_like "a member is signed in"

  describe "handling GET /guest_invitations/1" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation)
      GuestInvitation.expects(:find).with("1", anything).returns(@guest_invitation)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should assign the found guest_invitation for the view" do
      do_get
      assigns[:guest_invitation].should equal(@guest_invitation)
    end
  end

  describe "handling GET /guest_invitations/new" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation)
      GuestInvitation.stubs(:new).returns(@guest_invitation)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new guest_invitation" do
      GuestInvitation.expects(:new).returns(@guest_invitation)
      do_get
    end
  
    it "should not save the new guest_invitation" do
      @guest_invitation.expects(:save).never
      do_get
    end
  
    it "should assign the new guest_invitation for the view" do
      do_get
      assigns[:guest_invitation].should equal(@guest_invitation)
    end
    
  end

  describe "handling GET /guest_invitations/1/edit" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation)
      GuestInvitation.stubs(:find).returns(@guest_invitation)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found GuestInvitations for the view" do
      do_get
      assigns[:guest_invitation].should == @guest_invitation
    end
  end

  describe "handling POST /guest_invitations" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation, :to_param => "1")
      GuestInvitation.stubs(:new).returns(@guest_invitation)
    end
    
    describe "with successful save" do
      before(:each) do
        @guest_invitation.expects(:save).returns(true)
        @guest_invitation.stubs(:pending?).returns(false)
      end
      
      def do_post
        post :create, :guest_invitation => {}
      end
  
      it "should redirect to the new guest_invitation" do
        do_post
        response.should redirect_to(guests_path)
      end

      it "should show message confirming success" do
        do_post
        flash[:notice].should_not be_blank
      end
      
      describe "with immediate delivery" do
        before(:each) do
          @guest_invitation.stubs(:pending?).returns(true)
        end
        
        it "should notify the invitation will be sent" do
          @guest_invitation.stubs(:contact_method).returns('email')
          do_post
          flash[:notice].should match(/an invitation by email will be sent/i)
        end
      end
    end
    
    describe "with failed save" do

      def do_post
        @guest_invitation.expects(:save).returns(false)
        @guest_invitation.expects(:can_send?).never
        post :create, :guest_invitation => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('guests/index')
      end
      
    end
  end

  describe "handling PUT /guest_invitations/1" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation, :to_param => "1")
      GuestInvitation.stubs(:find).returns(@guest_invitation)
    end
    
    describe "with successful update" do

      def do_put
        @guest_invitation.expects(:update_attributes).returns(true)
        put :update, :id => "1"
      end

      it "should update the found guest_invitation" do
        do_put
        assigns(:guest_invitation).should equal(@guest_invitation)
      end

      it "should assign the found guest_invitation for the view" do
        do_put
        assigns(:guest_invitation).should equal(@guest_invitation)
      end

      it "should redirect to the guest_invitation" do
        do_put
        response.should redirect_to(guest_invitation_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @guest_invitation.expects(:update_attributes).returns(false)
        put :update, :id => "1"
      end

      it "should render show template" do
        do_put
        response.should render_template('show')
      end

    end
  end

  describe "handling DELETE /guest_invitations/1" do

    before(:each) do
      @guest_invitation = mock_model(GuestInvitation, :destroy => true)
      GuestInvitation.stubs(:find).returns(@guest_invitation)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should call destroy on the found guest_invitation" do
      @guest_invitation.expects(:destroy).returns(true) 
      do_delete
    end
  
    it "should redirect to the guest_invitations list" do
      do_delete
      response.should redirect_to(guests_path)
    end
  end
end
