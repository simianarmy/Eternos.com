# $Id$

class TwitterActivityStreamItemsController < ActivityStreamItemsController
  def index
    @twitter_activity_stream_items = TwitterActivityStreamItem.find(:all)
  end
  
  def show
    
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
    
  end
  
  def destroy
    @twitter_activity_stream_item.destroy
    flash[:notice] = "Successfully destroyed twitter activity stream item."
    redirect_to twitter_activity_stream_items_url
  end
  
  protected
  
  def load_item
    @item = @twitter_activity_stream_item = TwitterActivityStreamItem.find(params[:id])
    raise ActionController::MethodNotAllowed unless @twitter_activity_stream_item.member == current_user
  end
end
