# $Id$

class TwitterActivityStreamItemsController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']
  
  def index
    @twitter_activity_stream_items = TwitterActivityStreamItem.find(:all)
  end
  
  def show
    @twitter_activity_stream_item = TwitterActivityStreamItem.find(params[:id])
  end
  
  def new
    @twitter_activity_stream_item = TwitterActivityStreamItem.new
  end
  
  def create
    @twitter_activity_stream_item = TwitterActivityStreamItem.new(params[:twitter_activity_stream_item])
    if @twitter_activity_stream_item.save
      flash[:notice] = "Successfully created twitter activity stream item."
      redirect_to @twitter_activity_stream_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @twitter_activity_stream_item = TwitterActivityStreamItem.find(params[:id])
  end
  
  def update
    @twitter_activity_stream_item = TwitterActivityStreamItem.find(params[:id])
    if @twitter_activity_stream_item.update_attributes(params[:twitter_activity_stream_item])
      flash[:notice] = "Successfully updated twitter activity stream item."
      redirect_to @twitter_activity_stream_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @twitter_activity_stream_item = TwitterActivityStreamItem.find(params[:id])
    @twitter_activity_stream_item.destroy
    flash[:notice] = "Successfully destroyed twitter activity stream item."
    redirect_to twitter_activity_stream_items_url
  end
end
