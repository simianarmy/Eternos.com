# $Id$
#
# Class that implements logic for searching a member's data to populate the Timeline

class TimelineSearch
  cattr_reader :max_results, :type_action_map, :filter_action_map
  @@max_results = 50
  @@type_action_map = {
    :email      => :get_emails,
    :twitter    => :get_twitter_items,
    :facebook   => :get_facebook_items,
    :photos     => :get_images,
    :media      => :get_media,
    :activity_stream_comments => :get_activity_stream_comments,
    :content_comments => :get_content_comments,
    :blog       => :get_feed_items,
    :profile    => [:get_durations]
  }
  @@filter_action_map = {
    :artifact   =>  [:get_images, :get_stream_media], 
    :duration   =>  [:get_durations]
  }
  
  def initialize(user_id, dates, options={})
    @member = Member.find(user_id)
    @start_date, @end_date = dates
    @options = options
    @events = []
  end
  
  # Determines which search actions to execute
  # returns corresponding type_action_map keys in array
  def search_types
    @types ||= if @options[:type]
      @options[:type].split('|').map! {|t| t.to_sym}
    else
      type_action_map.keys
    end
  end
  
  # Determines which data to search for by checking options 
  # If no filter actions specified, uses @@type_action_map methods
  def search_methods
    # apply additional optional filters
    @methods = []
    filter_action_map.each_key do |k|
      @methods += filter_action_map[k] if @options[k]
    end
    unless @methods.any?
      @methods = search_types.map {|t| type_action_map[t]}.flatten.uniq
    end
    @methods
  end
  
  def results
    # do search 
    search_methods.each do |meth|
      RAILS_DEFAULT_LOGGER.debug "calling #{meth}..."
      if res = self.send(meth)
        RAILS_DEFAULT_LOGGER.debug "#{meth} returned #{res.size} items"
        res.each {|res| add_events(res)}
      end
    end
    RAILS_DEFAULT_LOGGER.debug "Done fetching items."
    remove_duplicates
  end
  
  def num_results
    @options[:empty] ? 0 : (@options[:max_results] || max_results).to_i
  end
  
  # Searchs items that have durations, like jobs & people
  def get_durations
    assocs = []
    assocs += @member.profile.duration_associations if @member.profile
    durations = assocs.compact.map {|ass| duration_query ass.searchlogic }
    if @member.address_book
      durations += duration_query @member.address_book.addresses.searchlogic
    end
    durations.flatten.compact
  end
  
  def get_facebook_items
    query @member.activity_stream.items.facebook.searchlogic
  end
  
  def get_twitter_items
    query @member.activity_stream.items.twitter.searchlogic
  end
  
  def get_stream_media
    query @member.activity_stream.items.with_attachment.searchlogic
  end
  
  def get_media
    query @member.contents.media.searchlogic
  end
  
  def get_images
    # workaround for seriously buggy searchlogic errors that crash when trying to 
    # use query method on searchlogic object.
    # Note that Photo needs a special not_deleted named_scope since using
    # deleted_at_null in the chain crashes
    date_query Photo.user_id_eq(@member.id).not_deleted.with_thumbnails.searchlogic
    # Seeing if newer searchlogic fixes above
    #query Photo.user_id_eq(@member.id).with_thumbnails.searchlogic
  end
  
  def get_emails
    query BackupEmail.belonging_to_user(@member.id).searchlogic
  end
  
  def get_feed_items
    query FeedEntry.belonging_to_user(@member.id).include_content.searchlogic
  end
  
  def get_activity_stream_comments
    # Tell generators not to execute the query
    srch = without_executing_query do
      date_query Comment.searchlogic
    end
    join_str = %Q( INNER JOIN activity_stream_items ON activity_stream_items.id = comments.commentable_id 
    AND comments.commentable_type = 'ActivityStreamItem' 
    INNER JOIN activity_streams ON activity_streams.id = activity_stream_items.activity_stream_id )
    
    srch.find(:all, 
      :joins => join_str,
      :conditions => {'activity_streams.id' => @member.activity_stream.id})
  end
  
  # In order to display comments independently of their 'commentable' object
  def get_content_comments
    # Searchlogic >= 2.4:
    # Hurray for searchlogic polymorphic association support!
    # BOO for random occurrences of 'The error occurred while evaluating nil.call!' !
    # Call date_query directly b/c we don't have deleted_at column in comments table
    #date_query Comment.commentable_content_type_user_id_eq(@member.id).searchlogic
    
    # FEATURE SWITCH FOR TESTING ONLY
    #return unless AppConfig['timeline_fb_comment_accounts'] && AppConfig['timeline_fb_comment_accounts'].include?(@member.id)
    
    # Tell generators not to execute the query
    srch = without_executing_query do
      date_query Comment.searchlogic
    end
    srch.find(:all, 
      :joins => "INNER JOIN contents ON contents.id = comments.commentable_id AND comments.commentable_type = 'Content'", 
      :conditions => {'contents.user_id' => @member.id})
  end
  
  def without_executing_query(&block)
    @no_execute = true
    res = block.call
    @no_execute = false
    res
  end
  
  # Helper for searching by type (constant or string)
  def by_type(type)
    case type.to_s
    when "FacebookActivityStreamItem"
      get_facebook_items
    when "TwitterActivityStreamItem"
      get_twitter_items
    when "BackupEmail"
      get_emails
    when "Photo"
      get_images
    when "WebVideo", "Audio", "Music"
      get_media
    when "FeedEntry"
      get_feed_items
    end
  end
  
  protected
  
  def facebook_source
    @facebook_source ||= @member.backup_sources.facebook.first
  end
  
  def add_events(*evts)
    evts.compact.flatten.each do |res|
      @events << TimelineEvent.new(res)
    end
  end
  
  # Takes Searchlogic Search object containing named scope chains & adds necessary
  # search filters
  def query(search)
    # Filter out deleted items
    search.deleted_at_null = true
    date_query search
  end
  
  def date_query(search)
    if @options[:proximity]
      # closest events before or after a date
      proximity_search search, @options[:proximity]
    else
      # Date range query
      # Only doing it this way cuz Searchlogic can't handle my between_dates named_scope
      s = search.after(@start_date).before(@end_date)
      @no_execute ? s : s.all
    end
  end
  
  # Similar to query method but for duration objects
  def duration_query(search)
    if @options[:proximity]
      # closest events before or after a date
      proximity_search search, @options[:proximity]
    else
      # Duplicates in_dates named_scope since we can't do 2+ variable named_scopes with searchlogic objects
      # Copy search params object in case we need to join results
      s2 = search.clone
      # standard date range query
      res = search.after(@start_date).before(@end_date).all
      # Simulate OR by doing separate query with different conditons & joining the results
      if Date.today > @start_date.to_date
        res += s2.before_duration(@end_date).all
      end
      res.uniq # avoid duplicates
    end
  end
  
  # Searches for event closest to start_date either before or after the date
  # Returns as array
  def proximity_search(search, direction)
    (direction == 'past') ? search.before(@start_date).sorted_desc(true) : search.after(@start_date).sorted(true)
    @no_execute ? search : [search.first].compact
  end
  
  # Removes potential duplicate media by checking which actions were executed 
  # and using media urls as unique keys
  # Returns updated @events array
  def remove_duplicates
    # Check for dups in facebook attachments & photo objects
    if search_types.include?(:facebook) && search_types.include?(:photos)
      fb_photo_urls = collect_facebook_attachment_urls
      RAILS_DEFAULT_LOGGER.debug "fb photo url hash: #{fb_photo_urls.keys.inspect}"
      RAILS_DEFAULT_LOGGER.debug "events before rejecting: #{@events.size}"
      @events.reject!{|e| (e.type == 'photo') && fb_photo_urls[e.event.url]}
      RAILS_DEFAULT_LOGGER.debug "events after rejecting: #{@events.size}"
    end
    @events
  end
  
  private
  
  # Returns hash of facebook attachment photo urls as keys
  def collect_facebook_attachment_urls
    @events.select{|e| (e.type == 'facebook_activity_stream_item') && (e.attachment_type == 'photo')}.inject(Hash.new){|h,e| h[e.event.url] = 1; h}
  end
end

class TimelineSearchFaker < TimelineSearch
  def initialize(user_id, dates, options={})
    require 'benchmark_helper'
    require 'random_data'
    require 'faker'
    require "date"
    
    super(user_id, dates, options)
    @methods = search_methods.reject { |t| [:get_profile].include? t }
  end
  
  def results
    return unless @methods.any?
    max_tries = 1000
    tries = 0
    until @events.size >= num_results || tries >= max_tries
      add_events pick_random_result 
      tries += 1
    end
    if search_types.include? :profile
      add_events get_profile
    end
    set_dates
    @events
  end
  
  def set_dates
    min = Date.parse @start_date
    max = Date.parse @end_date
    dates = (min..max).to_a
    
    # Assign random date within range to each result
    BenchmarkHelper.rails_log('TimelineSearchFaker set random dates') do
      # Random.date_between takes foreeevvveeeerrr...
      # Using my own faster way
      @events.each do |e| 
        e.start_date = dates.rand.to_s
        if e.respond_to? :end_date
          e.end_date = (rand(1) == 0 ) ? max : nil
        end
      end
    end
  end
  
  def pick_random_result
    self.send(@methods.rand)
  end
  
  # Returns random activity
  def get_facebook_items
    ActivityStreamItem.facebook.rand
  end
  
  def get_twitter_items
    ActivityStreamItem.twitter.rand
  end
   
  # Returns random photo from random album
  def get_images
    Photo.all.rand
  end
  
  def get_media
    [WebVideo.all.rand] + [Audio.all.rand]
  end
  
  def get_emails
    BackupEmail.all.rand
  end
  
  def get_feed_items
    FeedEntry.all.rand
  end
  
  def get_stream_media
    ActivityStreamItem.with_attachment.with_photo.rand
  end
  
  def get_profile
    if p = Profile.all.rand
      [p.medicals, p.medical_conditions, p.families]
    end
  end
  
  def get_durations
    returning Array.new do |durations|
      if p = Profile.all.rand
        durations = p.timeline(@start_date, @end_date).values
      end
      if a = Address.all.rand
        durations << a
      end
    end
  end 
end