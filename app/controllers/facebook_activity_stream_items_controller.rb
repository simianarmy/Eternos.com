class FacebookActivityStreamItemsController < ActivityStreamItemsController
  
  def index
    @facebook_activity_stream_items = FacebookActivityStreamItem.find(:all)
  end
  
  def show
    
  end
  
  def new
    @facebook_activity_stream_item = FacebookActivityStreamItem.new
  end
  
  def create
    @facebook_activity_stream_item = FacebookActivityStreamItem.new(params[:facebook_activity_stream_item])
    if @facebook_activity_stream_item.save
      flash[:notice] = "Successfully created facebook activity stream item."
      redirect_to @facebook_activity_stream_item
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def destroy
    @facebook_activity_stream_item.destroy
    flash[:notice] = "Successfully destroyed facebook activity stream item."
    redirect_to facebook_activity_stream_items_url
  end
  
  protected
  
  
end
