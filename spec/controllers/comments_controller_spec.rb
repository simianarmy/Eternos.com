# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, "on create" do
  fixtures :all
  #integrate_views
 
  it_should_behave_like "a member is signed in"
  before(:each) do
    @commentable = stories(:wedding_story)
  end
  
  it " should render new template" do
    post :create
    response.should render_template(:new)
  end
  
  it " should render new template when model is invalid" do
    Comment.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it " should display flash notice when model is invalid" do
    post :create
    assigns[:comment].errors.should_not be_empty
  end
  
  it " should display success on successful invitation" do
    create_comment 
    flash[:notice].should == "Comment added"
  end
  
  it "should belong to logged in user" do
    create_comment
    assigns[:comment].author.should be_eql(@user)
  end
  
  it "should belong to commentable object" do
    create_comment
    assigns[:comment].commentable.should be_an_instance_of Story
  end
  
  it "should add to comments table" do
    lambda {
      create_comment
    }.should change(Comment, :count).by(1)
  end
  
  it "should strip html tags from comment before saving" do
    xhr :post, :create, :comment => {:comment => 'snoo<script>evil.js.here</script>snoo', 
      :commentable => @commentable}
    assigns[:comment].comment.should == 'snooevil.js.heresnoo'
  end
  
  def create_comment(commentable=@commentable)
    xhr :post, :create, :comment => {:comment => 'snoo snoo', :commentable => commentable}
  end
end

  
