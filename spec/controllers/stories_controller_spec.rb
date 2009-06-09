# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesController, "a new story" do
  include StorySpecHelper
  integrate_views
  it_should_behave_like "a member is signed in"
  
  it "should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  # describe "with recording" do
  #     it "last one should be found and displayed if pending" do
  #       session[:last_recording] = 1
  #       Recording.expects(:find).with(1).returns(@rec = mock('Recording'))
  #       @rec.stubs(:id).returns(1)
  #       @rec.stubs(:state)
  #       get :new, :type => 'recording'
  #       assigns[:recording].should be_eql(@rec)
  #     end
  #   end
  describe "on create" do
    include ContentAuthorizationSpecHelper
    include GuestSpecHelper
  
    it "should redirect to index with a notice on success" do
      Story.any_instance.stubs(:valid?).returns(true)
      Story.any_instance.stubs(:save).returns(true)
      post 'create'
      flash[:notice].should_not be_nil
      response.should redirect_to(stories_path)
    end

    it "should re-render new template with errors when required params are missing" do
      post 'create', :story => valid_story_attributes(:title=>nil)
      assigns[:story].should be_new_record
      flash[:notice].should be_nil
      response.should render_template('new')
    end

    it "should be saved with proper authorization level" do
      Story.any_instance.expects(:privacy_settings=).with(:authorization => ContentAuthorization::AuthPublic)
      post 'create', :story => valid_story_attributes(all_public_attributes)
    end
  
    it "should be saved with authorized accessors when partial authorization selected" do
      @guest = create_guest_with_host(@member, :circle => @circle = create_circle)
      Story.any_instance.expects(:authorize_for_user).with(@guest, @guest.circle)
      Story.any_instance.expects(:authorize_for_group).with(@circle)
      post 'create', :story => valid_story_attributes(partial_privacy_attributes([@guest],[@circle]))
    end
  
    it "should create and assign new category" do
      post 'create', :story => valid_story_attributes.merge(:new_category_name=>'foo')
      assigns[:story].category.name.should == 'foo'
    end
    
    describe "with recording" do
      it "should assign recording to story if recording session id exists" do
        @recording = mock_model(Recording)
        Story.expects(:new).returns(@story = mock_model(Story))
        @story.expects(:recording_id=).with(@recording.id)
        @story.stubs(:save).returns(true)
        session[:story_last_recording] = @recording.id
        post 'create'
      end
    end
  end

  describe "" do
    before(:each) do
      @story = create_story(:member => @member)
    end
    
    describe "on show" do  
      it "should render show template" do
        get :show, :id => @story.id
        response.should render_template(:show)
      end
    end

    describe "updating a story" do
      it "should replace in-place-editor field with original value if validation fails" do
        @story.stubs(:valid?).returns(false)
        og_title = @story.title
        # Perhaps this belongs in views test
        ajax_update({}, :title=>'')
        assert_rjs :replace_html, controller.dom_id(@story), og_title
      end
  
      def ajax_update(params={}, story_params={})
        xhr :post, :update, {:id => @story.id, :domId => controller.dom_id(@story), 
          :story => story_params}.merge(params)
      end
    end
  end
end
