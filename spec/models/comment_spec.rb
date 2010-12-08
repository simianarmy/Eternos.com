# $Id$
require File.dirname(__FILE__) + '/../spec_helper'

module CommentSpecHelper
  def valid_attributes(user, commentable)
    {:comment => Faker::Lorem.sentence, :author => user, :commentable => commentable}
  end
end

describe Comment do
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
  
  describe "creating" do
    def gen_comment(user, commentable)
      new_comment(valid_attributes(user, commentable))
    end
    
    before(:each) do 
      @user = create_member
      @story = create_story
      @comment = gen_comment @user, @story
    end
  
    it "should allow member as author" do
      lambda {
        comment = gen_comment(nil, create_story)
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

  describe "" do
    before(:each) do
      @user = create_member
      @story = create_story
      @comment = create_comment(valid_attributes(@user, @story))
    end
    
    describe "fetching comments" do
      it "should find all comments for commentable object" do
        @story.add_comment c2 = create_comment(:commentable => @story)
        Story.find_comments_for(@story).should have(2).items
      end
      
      it "should return comments in thread" do
        @story.add_comment c2 = create_comment(:commentable => @story)
        @comment.thread.should have(2).items
      end
      
      it "should return comments sorted by date ascending" do
        c2 = create_comment(:commentable => @story)
        @story.add_comment c2
        @comment.thread.first.should == @comment
        c3 = create_comment(:commentable => @story, :created_at => 5.years.ago)
        @story.add_comment c3
        @comment.thread.first.should == c3
      end
      
      it "should return prior comments in thread" do
        @story.add_comment c2 = create_comment(:commentable => @story)
        @comment.thread_before.should be_empty
        c3 = create_comment(:commentable => @story, :created_at => 5.years.ago)
        c4 = create_comment(:commentable => @story, :created_at => 6.years.ago)
        @comment.thread_before.should == [c4, c3]
      end
      
      it "should return later comments in thread" do
        @story.add_comment c2 = create_comment(:commentable => @story, :created_at => 1.hour.from_now)
        @comment.thread_after.should == [c2]
        c3 = create_comment(:commentable => @story, :created_at => 5.years.ago)
        c4 = create_comment(:commentable => @story, :created_at => 1.second.from_now)
        @comment.thread_after.should == [c4, c2]
      end
    end
  end
  
  describe "serializing" do
    before(:each) do
      @user = create_member
      @story = create_story
      @comment = create_comment(valid_attributes(@user, @story))
    end
    
    it "should serializable to json" do
      lambda {
        @comment.as_json
      }.should_not raise_error
    end
    
    it "should include prior comments in json" do
      obj = ActiveSupport::JSON.decode(@comment.to_json)
      obj.should have_key('earlier_comments')
    end
    
    it "should not blow up when serializing prior comments" do
      c3 = create_comment(:commentable => @story, :created_at => 5.years.ago)
      c4 = create_comment(:commentable => @story, :created_at => 6.years.ago)
      lambda {
        @comment.to_json
      }.should_not raise_error
    end
    
    it "should not recursively serialize its own prior comments" do
      c3 = create_comment(:commentable => @story, :created_at => 5.years.ago)
      c4 = create_comment(:commentable => @story, :created_at => 6.years.ago)
      obj = ActiveSupport::JSON.decode(@comment.to_json)
      obj['earlier_comments'][0][0].should == c4.comment
    end
  end
end
