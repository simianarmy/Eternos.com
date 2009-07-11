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
    @facebook_friends = @profile.facebook_content.friends
    @facebook_groups = @profile.facebook_content.groups
    if bs = current_user.backup_sources
      bs.each do |source|
        (@photo_albums ||= []) << source.backup_photo_albums
      end
    end
    @activity_streams = current_user.activity_streams
  end
  
  # GET /timeline/search/member_id/start_date/end_date/*opts
  def search
    # Member or guest view
    
#    member_view = (params[:id].to_i == current_user.id)
#    filters = parse_search_filters
#    
#    @response = TimelineRequestResponse.new(request.url)
#    search = filters[:fake] ? 
#      TimelineSearchFaker.new([params[:start_date], params[:end_date]], filters) : 
#      TimelineSearch.new(params[:id], [params[:start_date], params[:end_date]], filters)
#    @response.results = search.results
    
    @response = TimelineRequestResponse.new(request.url)
    
    render :json => @response.to_json
  end
  
  private
    
  def find_host
    @host = current_user.get_host
  end
  
  def parse_search_filters
    (params[:filters] || []).inject({}) do |res, el| 
      k,v = el.to_s.split('=')
      res[k.to_sym] = v.nil? ? "1" : v
      res
    end
  end
end
