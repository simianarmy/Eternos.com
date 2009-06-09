require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesController do
  it_should_behave_like "a member is signed in"
  def mock_messages(stubs={})
    @mock_messages ||= mock_model(Message, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all messages as @messages" do
      Message.expects(:find).with(:all,{}).returns([mock_messages])
      get :index
      assigns[:messages].should == [mock_messages]
    end

  end

  describe "responding to GET show" do
    
    it "should expose the requested messages as @message" do
      Message.expects(:find).with("37", anything).returns(mock_messages)
      get :show, :id => "37"
      assigns[:message].should equal(mock_messages)
    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new messages as @message" do
      Message.expects(:new).returns(mock_messages)
      @mock_messages.expects(:message=)
      get :new
      assigns[:message].should equal(mock_messages)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested messages as @message" do
      Message.expects(:find).with("37", anything).returns(mock_messages)
      get :edit, :id => "37"
      assigns[:message].should equal(mock_messages)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      it "should expose a newly created message as @message" do
        Message.expects(:new).with({'these' => 'params'}).returns(mock_messages(:save => true))
        post :create, :message => {:these => 'params'}
        assigns(:message).should equal(mock_messages)
      end

      it "should redirect to the created message" do
        Message.stubs(:new).returns(mock_messages(:save => true))
        post :create, :message => {}
        response.should redirect_to(message_url(mock_messages))
      end
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved message as @message" do
        Message.stubs(:new).with({'these' => 'params'}).returns(mock_messages(:save => false))
        post :create, :message => {:these => 'params'}
        assigns(:message).should equal(mock_messages)
      end

      it "should re-render the 'new' template" do
        Message.stubs(:new).returns(mock_messages(:save => false))
        post :create, :message => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested message" do
        Message.expects(:find).with("37", anything).returns(mock_messages)
        mock_messages.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :message => {:these => 'params'}
      end

      it "should expose the requested message as @message" do
        Message.stubs(:find).returns(mock_messages(:update_attributes => true))
        controller.expects(:load_settings_view_objects)
        put :update, :id => "1"
        assigns(:message).should equal(mock_messages)
      end

      it "should redirect to the message" do
        Message.stubs(:find).returns(mock_messages(:update_attributes => true))
        controller.expects(:load_settings_view_objects)
        put :update, :id => "1"
        response.should redirect_to(message_url(mock_messages))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested message" do
        Message.expects(:find).with("37", anything).returns(mock_messages)
        mock_messages.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :message => {:these => 'params'}
      end

      it "should expose the message as @message" do
        Message.stubs(:find).returns(mock_messages(:update_attributes => false))
        put :update, :id => "1"
        assigns(:message).should equal(mock_messages)
      end

      it "should re-render the 'edit' template" do
        Message.stubs(:find).returns(mock_messages(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested messages" do
      Message.expects(:find).with("37", anything).returns(mock_messages)
      mock_messages.expects(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the messages list" do
      Message.stubs(:find).returns(mock_messages(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(messages_url)
    end

  end

end
