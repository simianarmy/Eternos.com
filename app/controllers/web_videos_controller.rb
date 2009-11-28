# $Id$

class WebVideosController < TimelineEventsController
  
  def show
    respond_to do |format|
      format.flv { send_protected_content(@item.url, 'video/x-flv') }
      format.html
    end
  end
  
  private
  
end