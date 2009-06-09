# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

module CommentSpecHelper
  def valid_attributes(user, commentable)
    {:comment => 'foo foo', :author => user, :commentable => commentable}
  end
end

describe Comment do
  fixtures :all
  include CommentSpecHelper
  
  before(:each) do 
    @comment = Comment.new
  end
  
  it "should not be valid without required attributes" do
    @comment.should_not be_valid
    @comment.attributes = valid_attributes(create_member, create_story)
    @comment.should be_valid
  end
  
  it "should respond to author" do
    @comment.should respond_to 'author'
  end
end

describe Comment, "on create" do
  fixtures :all
  
  include CommentSpecHelper
  before(:each) do 
    @comment = Comment.new(valid_attributes(@user = create_member, @story = create_story))
  end
  
  it "should allow member as author" do
    lambda {
      comment = Comment.new(valid_attributes(nil, create_story))
      comment.author = @user
      comment.save
    }.should change(Comment, :count).by(1)
  end
  
  it "should allow author assignment using member object" do
    lambda {
      @comment.author = @user
      @comment.save
    }.should change(Comment, :count).by(1)
  end
  
  it "should assign user_id from author attribute" do
    @comment.save
    @comment.author.should be_eql(@user)
  end
  
  it "should belong to commentable object" do
    @comment.save
    @comment.commentable.should be_eql(@story)
  end
  
  it "should be created" do
    lambda {
      @comment.save
    }.should change(Comment, :count).by(1)
  end
end
