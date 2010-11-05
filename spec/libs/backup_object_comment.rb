# $Id$

require File.dirname(__FILE__) + '/../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../facebook_spec_helper')

ActiveRecord::Schema.define(:version => 0) do  
  create_table :scratches, :force => true do |t| 
    t.string :name
  end 
end

class Scratch < ActiveRecord::Base
  acts_as_commentable
  include BackupObjectComment
end

describe BackupObjectComment do 
  def create_commentable_object
    Scratch.create(:name => Faker::Lorem.words(1))
  end
  
  describe "facebook comments" do
    include FacebookSpecHelper
     include FacebookProxyObjectSpecHelper
     
    describe "an object without comments" do
      describe "synching" do
        it "with an empty list should save the passed comments" do
          @obj = create_commentable_object
          comments = [new_proxy_fb_comment(fb_comment), new_proxy_fb_comment(fb_comment)]
          lambda {
            @obj.synch_backup_photo_comments comments
          }.should change(@obj.comments, :count).by(comments.size)
        end
        
        it "with matching items should not modify anything" do
          @obj = create_commentable_object
          comments = [new_proxy_fb_comment(fb_comment), new_proxy_fb_comment(fb_comment)]
          @obj.synch_backup_photo_comments comments
          @obj.expects(:add_backup_comment).never
          @obj.reload.synch_backup_photo_comments comments
        end
        
        it "should add any comments not already in list to existing list" do
          @obj = create_commentable_object
          comments = [new_proxy_fb_comment(fb_comment), new_proxy_fb_comment(fb_comment)]
          @obj.synch_backup_photo_comments comments
          sleep(1) # sleep to force different comment post time
          comments.push new_proxy_fb_comment(fb_comment)
          @obj.reload.synch_backup_photo_comments comments
          @obj.comments.size.should == comments.size
        end
        
        it "should not remove any existing comments if passed an empty list" do
          @obj = create_commentable_object
          comments = [new_proxy_fb_comment(fb_comment), new_proxy_fb_comment(fb_comment)]
          @obj.synch_backup_photo_comments comments
          lambda {
            @obj.synch_backup_photo_comments nil
            @obj.synch_backup_photo_comments []
          }.should_not change(@obj.comments, :count)
        end
      end
    end
  end
end
  