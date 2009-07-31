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
    # Use map table to map dev users to their staging account
    @member = current_user
    @member_name = @member.full_name
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
        (@rss_feeds ||= []) << source.feed if source.respond_to? :feed
        (@emails ||= []) << source.backup_emails if source.respond_to? :backup_emails
      end
    end
    @activity_stream = current_user.activity_stream || current_user.build_activity_stream
  end
  
  # GET /timeline/search/format/member_id/start_date/end_date/*opts
  def search
    # Member or guest view
    #member_view = (params[:id].to_i == current_user.id)
    
    # Proxy ajax request for dev env. to staging server
    if (ENV['RAILS_ENV'] == 'development') && (dev_map = DevStagingMap.find_by_dev_user_id(current_user.id))
      url = request.url.dup
      url.gsub!(/dev\./, 'staging.')
      url.gsub!(/js\/\d+\//, "js/#{dev_map.staging_user_id}/")
      @json ||= Curl::Easy.perform(url).body_str
      @response = ActiveSupport::JSON.decode(@json) if @json
    else
      # Rails has already parsed the url into params hash for us - no point in doing it again.
      @response ||= TimelineRequestResponse.new(request.url, params)
      @response.execute
    end
    respond_to do |format|
      format.js {
        render :json => @response
      }
      format.html {
        @json = @response.to_json
      }
    end
  end
  
  def blank
  end
  
  private
    
  def find_host
    @host = current_user.get_host
  end
  
end
