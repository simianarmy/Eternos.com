# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe ElementsController do
  fixtures :all
  integrate_views
  
  it_should_behave_like "a member is signed in"
  
  before(:each) do 
    @story = create_story(:member => @member)
    @element = create_element(:story => @story)
  end
  
  it "index action should render index template" do
    get :index, :story_id => @story.id
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => @element.id, :story_id => @story.id
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new, :story_id => @story.id
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Element.any_instance.stubs(:valid?).returns(false)
    post :create, :story_id => @story.id
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Element.any_instance.stubs(:valid?).returns(true)
    post :create, :story_id => @story.id
    response.should redirect_to(story_element_url(@story, assigns[:element]))
  end
  
  it "edit action should render show template" do
    get :edit, :id => @element.id, :story_id => @story.id
    response.should render_template(:show)
  end
  
  it "update action should render show template when model is invalid" do
    Element.any_instance.stubs(:valid?).returns(false)
    put(:update, :id => @element.id, :story_id => @story.id)
    response.should render_template(:show)
  end
  
  it "update action should redirect when model is valid" do
    Element.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @element.id, :story_id => @story.id
    response.should redirect_to(story_element_url(@story, assigns[:element]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => @element.id, :story_id => @story.id
    response.should redirect_to(story_elements_url(@story))
    Element.exists?(@element.id).should be_false
  end
end
