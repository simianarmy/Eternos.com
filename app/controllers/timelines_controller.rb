# $Id$

require 'timeline_request_response'
require 'benchmark_helper'

class TimelinesController < ApplicationController
  before_filter :login_required, :except => [:search]
  require_role ['Guest', 'Member'], :for_all_except => :search
  before_filter :set_facebook_connect_session
  
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
    @member_name = @member.full_name
    @tl_start_date, @tl_end_date = cache("tl_date_range:#{@member.id}", session[:refresh_timeline]) { 
      @member.timeline_span 
    }
    @fake = 'fake' if params[:fake]
    
    if @member.need_backup_setup?
      flash[:error] = render_to_string :partial => 'setup_link_flash'
        
      @hide_timeline = true
    else
      if !@member.has_backup_data?
        flash[:notice] = "We are backing up your data and will email you when it is ready to view!"
        @hide_timeline = true
      end
      
      if @member.backup_in_progress? && ((estimated_time = @member.backup_state.time_remaining) > 0)
        estimated = help.distance_of_time_in_words(Time.now, Time.now + estimated_time)
        flash[:notice] = "Backup in progress...estimated completion in #{estimated}."
      end
      
      #@backups = BackupSourceJob.descend_by_created_at[0..3] #
      @backups = @member.backup_sources.map(&:latest_backup).compact rescue []
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
    if (ENV['RAILS_ENV'] == 'development') && (dev_map = DevStagingMap.find_by_dev_user_id(current_user.id)) && dev_map.mapped_id > 0
      proxy_search(dev_map)
      @response = ActiveSupport::JSON.decode(@json) if @json
    else
      md5 = Digest::MD5.hexdigest(request.url)
      # Disable memcache by forcing refresh for now...
      refresh = true || session[:refresh_timeline] #|| current_user.refresh_timeline?
      uid = current_user ? current_user.id : 0
      
      BenchmarkHelper.rails_log("Timeline search #{request.url}") do
        @response = cache(md5, refresh) { TimelineRequestResponse.new(uid, request.url, params).to_json }
      end
      session[:refresh_timeline] = nil
    end
    respond_to do |format|
      format.js {
        render :json => @response # already in json format
      }
      # html for debug view
      format.html {
        #render :inline => @response
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
  
  def proxy_search(dev_map)
    uri = URI.parse request.url
    uri.host = dev_map.env + '.eternos.com'
    uri.path.gsub!(/js\/\d+\//, "js/#{dev_map.mapped_id}/")
    uri.path += '/mapped=1'
    uri.port = 80
    unless @json
      RAILS_DEFAULT_LOGGER.debug "Proxy calling #{uri.to_s}"
      @json = Curl::Easy.perform(uri.to_s).body_str
    end
  end
  
end
