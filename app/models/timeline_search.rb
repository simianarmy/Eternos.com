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
    :blog       => :get_feed_items,
    :profile    => [:get_profile, :get_durations]
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
  
  def search_types
    types = if @options[:type]
      @options[:type].split('|').map! {|t| t.to_sym}
    else
      type_action_map.keys
    end
  end
  
  def search_methods
    # apply additional optional filters
    methods = []
    filter_action_map.each_key do |k|
      methods += filter_action_map[k] if @options[k]
    end
    unless methods.any?
      methods = search_types.map {|t| type_action_map[t]}.flatten.uniq
    end
    methods
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
    @events
  end
  
  def num_results
    @options[:empty] ? 0 : (@options[:max_results] || max_results).to_i
  end
  
  def get_profile
    if p = @member.profile
      [p.medicals, p.medical_conditions, p.families]
    end
  end
  
  def get_durations
    # TODO: Proximity search support
    # returning Array.new do ... not working out for me
    durations = []
    if p = @member.profile
      durations = p.timeline(@start_date, @end_date).values
    end
    if @member.address_book.addresses.any?
      durations << @member.address_book.addresses.in_dates(@start_date, @end_date)
    end
    durations.flatten
  end
  
  def get_facebook_items
    query @member.activity_stream.items.facebook.search
  end
  
  def get_twitter_items
    query @member.activity_stream.items.twitter.search
  end
  
  def get_stream_media
    query @member.activity_stream.items.with_attachment.search
  end
  
  def get_images
    query @member.contents.photos.search
  end
  
  def get_emails
    query BackupEmail.belonging_to_user(@member.id).search
  end
  
  def get_feed_items
    items = []
    @member.backup_sources.blog.each do |feed|
      items << query(feed.feed.entries.search)
    end
    items.flatten
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
    if @options[:proximity]
      # closest events before or after a date
      proximity_search search, @options[:proximity]
    else
      # Date range query
      # Only doing it this way cuz Searchlogic can't handle my between_dates named_scope
      search.after(@start_date).before(@end_date).all
    end
  end
  
  # Searches for event closest to start_date.  
  def proximity_search(search, direction)
    (direction == 'past') ? search.before(@start_date).sorted_desc(true) : search.after(@start_date).sorted(true)
    [search.first]
  end
end

class TimelineSearchFaker < TimelineSearch
  def initialize(user_id, dates, options={})
    require 'benchmark_helper'
    require 'random_data'
    require 'faker'
    
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