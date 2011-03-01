class LinkedinActivityStreamItemsController < ActivityStreamItemsController

  def index
    @linkedin_activity_stream_items = LinkedinActivityStreamItem.find(:all)
  end

  def show

  end

  def new
    @linkedin_activity_stream_item = LinkedinActivityStreamItem.new
  end

  def edit

  end

  def create
    @linkedin_activity_stream_item = LinkedinActivityStreamItem.new(params[:linkedin_activity_stream_item])

      if @linkedin_activity_stream_item.save
        flash[:notice] = "Successfully created Linked in activity stream item."
        redirect_to @linkedin_activity_stream_item
      else
         render :action => 'new'
      end
  end

  def destroy
    @linkedin_activity_stream_item.destroy
    flash[:notice] = "Successfully destroyed Linked In activity stream item."
    redirect_to linkedin_activity_stream_items_url
  end

  protected
end
