# $Id$

require 'timeline_request_response'
require 'benchmark_helper'

class TimelinesController < ApplicationController
  before_filter :login_required, :except => [:search]
  require_role ['Guest', 'Member'], :for_all_except => :search
  
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
    @tl_start_date, @tl_end_date = cache("tl_date_range:#{@member.id}", session[:refresh_timeline]) { 
      @member.timeline_span 
    }
    @fake = 'fake' if params[:fake]
    
    @hide_timeline = if @member.need_backup_setup?
      flash[:error] = "<h4>You do not have any accounts to backup yet!</h4>To setup your online accounts, click the 'account settings' link above and go to Step 2."
    elsif !@member.has_backup_data?
      flash[:notice] = "We are backing up your data and will email you when it is ready to view!"
    end
    
    if @member.backup_in_progress? && ((estimated_time = @member.backup_state.time_remaining) > 0)
      estimated = help.distance_of_time_in_words(Time.now, Time.now + estimated_time)
      flash[:notice] = "Backup in progress...will complete in #{estimated}."
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
    if false && (ENV['RAILS_ENV'] == 'development') && (dev_map = DevStagingMap.find_by_dev_user_id(current_user.id)) &&
      (dev_map.staging_user_id > 0)
      uri = URI.parse request.url
      uri.host = 'staging.eternos.com'
      uri.path.gsub!(/js\/\d+\//, "js/#{dev_map.staging_user_id}/")
      uri.port = 80
      RAILS_DEFAULT_LOGGER.debug "Proxy calling #{uri.to_s}"
      @json ||= Curl::Easy.perform(uri.to_s).body_str
      @response = ActiveSupport::JSON.decode(@json) if @json
    else
      md5 = Digest::MD5.hexdigest(request.request_uri)
      refresh = session[:refresh_timeline] #|| current_user.refresh_timeline?
      
      BenchmarkHelper.rails_log("Timeline search #{request.url}") do
        @response = cache(md5, refresh) { TimelineRequestResponse.new(request.url, params).to_json }
      end
      session[:refresh_timeline] = nil
    end
    respond_to do |format|
      format.js {
        render :json => @response # already in json format
      }
      # html for debug view
      format.html {
        @json = @response
        @response = ActiveSupport::JSON.decode(@response)
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
