# $Id$

require 'timeline_request_response'
require 'benchmark_helper'

class TimelinesController < ApplicationController
  before_filter :login_required, :except => [:search, :tag_cloud]
  require_role ['Guest', 'Member'], :for_all_except => [:search, :tag_cloud]
  before_filter :ensure_subdomain
  before_filter :set_facebook_connect_session, :except => [:search, :tag_cloud]
  before_filter :load_member_home_presenter, :except => [:search, :tag_cloud]
  
  ssl_required :blank # Dummy action so that all actions forced to non-ssl
  
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
    @tl_start_date, @tl_end_date = Rails.cache.fetch("tl_date_range:#{@member.id}", :force => session[:refresh_timeline]) { 
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
      
      # Get backup status for progress bars
      # DISABLED
      #@backups = @member.backup_sources.map(&:latest_backup).compact rescue []
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
      Rails.logger.debug "Using dev map #{dev_map.inspect}"
      @response = ActiveSupport::JSON.decode(@json) if @json
    else
      filters = parse_search_filters params[:filters]
      Rails.logger.debug "searching with params => #{params.inspect}"
      Rails.logger.debug "searching with filters => #{filters.inspect}"
      refresh = filters[:no_cache] || force_cache_reload?(:timeline) #|| current_user.refresh_timeline?
      uid = current_user ? current_user.id : 0
      md5 = Digest::MD5.hexdigest(request.url)
      
      BenchmarkHelper.rails_log("Timeline search #{request.url}") {
        @response = Rails.cache.fetch(md5, :force => refresh, :expires_in => 10.minutes) { 
          TimelineRequestResponse.new(uid, request.url, params, filters).execute
        }
        #Rails.logger.debug "Timeline search response = #{@response.inspect}"
      }
      use_cache!(:timeline)
    end
    respond_to do |format|
      format.js {
        render :json => @response # Will call as_json??
      }
      # html for debug view
      format.html {
        render :layout => false
      }
    end
  end
  
  # Returns JSON for jquery tag cloud widget
  def tag_cloud
    #@tags = {:tags => [{:tag => 'foo', :freq => 10}, {:tag => 'fee', :freq => 5}]}
    limit = params[:limit] || MAX_TAG_CLOUD_SIZE
    # Cache parsed results
    tags = Rails.cache.fetch("tag_cloud_#{current_user.id}", :expires_in => 24.hours) do
      # Lookup word_counts serialized hash for this user
      if txt = RawText.find_by_user_id(current_user.id)
        wcs = txt.word_counts
        wcs.keys.inject([]) {|res, k| res << {:tag => k, :freq => wcs[k]}; res }
      else
        []
      end
    end
    # If limit > 0, sort descending & return up to limit
    if limit > 0
      # tags is frozen, can't use bang methods
      tags = tags.sort{|a,b| b[:freq] <=> a[:freq]}
      tags = tags.slice(0, limit) # can't use slice! for some reason
    end
    Rails.logger.debug "Returning #{tags.size} tags"
    respond_to do |format|
      format.js { render :json => {:tags => tags} }
    end
  end
  
  def blank
  end
  
  protected
  
  # # Override to make sure member_home does not use ssl
  #   def ssl_required? 
  #     if action_name == 'show'
  #       false
  #     else
  #       super
  #     end
  #   end
  def ensure_subdomain
    redirect_to '/vdashboard' if current_subdomain == 'vault'
  end
  
  def find_host
    @host = current_user.get_host
  end
  
  def proxy_search(dev_map)
    uri = URI.parse request.url
    uri.scheme = 'http'
    uri.host = dev_map.env + '.eternos.com'
    uri.path.gsub!(/js\/\d+\//, "js/#{dev_map.mapped_id}/")
    uri.path += '/mapped=1'
    uri.port = 80
    unless @json
      RAILS_DEFAULT_LOGGER.debug "Proxy calling #{uri.to_s}"
      @json = Curl::Easy.perform(uri.to_s).body_str
    end
  end
  
  def parse_search_filters(args)
    (args || []).inject({}) do |res, el| 
      el.split('&').each do |kv|
        k,v = kv.to_s.split('=')
        res[k.to_sym] = v.nil? ? "1" : v
      end
      res
    end
  end
end
