# $Id$
class CommentsController < ApplicationController
  before_filter :login_required
  require_role ["Guest", "Member"]
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    
    respond_to do |format|
      if @comment.save
        flash[:notice] = "Comment added"
        format.html { redirect_to "/" }
        format.js
      else
        flash[:notice] = @comment.errors.full_messages
        format.html { render :action => :new }
        format.js
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    
    if comment.author != current_user
      flash[:notice] = "You are not authorized to delete the comment!"
    else
      flash[:notice] = "Comment deleted"
    end
    respond_to do |format|
      format.html { render :action => :destroy }
      format.js
    end
  end
end
