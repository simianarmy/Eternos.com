# $Id$

require 'timeline_search'

class TimelinesController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']

  def guest_index
    find_host
    permit "guest of :host" do
      @stories = @host.authorized_stories(current_user)
    end
    layout 'guest'
  end
  
  # Display timeline page
  # Determine initial timeline beginning & end dates.
  # Collect any other data that the timeline page needs on load.
  # All other requests will be done via AJAX queries.0
  def show
    @member = current_user
    respond_to do |format|
      format.html
    end
  end
  
  def debug
    # Right now just raw info for debug output
    @profile = current_user.profile
    @facebook_profile = @profile.facebook_data
    if @profile.facebook_content
      @facebook_friends = @profile.facebook_content.friends
      @facebook_groups = @profile.facebook_content.groups
    end
    if bs = current_user.backup_sources
      bs.each do |source|
        (@photo_albums ||= []) << source.backup_photo_albums
      end
    end
    @activity_stream = current_user.activity_stream || current_user.build_activity_stream
  end
  
  # GET /timeline/search/member_id/start_date/end_date/*opts
  def search
    # Member or guest view
    
    member_view = (params[:id].to_i == current_user.id)
        
    # Rails has already parsed the url into params hash for us - no point in doing it again.
    @response = TimelineRequestResponse.new(request.url, params)
    @response.execute
    
    respond_to do |format|
      format.js {
        render :json => @response.to_json
      }
      format.html {
        @json = @response.to_json
      }
    end
  end
  
  private
    
  def find_host
    @host = current_user.get_host
  end
  
end
