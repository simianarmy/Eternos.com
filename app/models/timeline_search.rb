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
    :photos     => [:get_backup_photos],
    :blog       => :get_feed_items,
    :profile    => [:get_profile, :get_durations]
  }
  @@filter_action_map = {
    :artifact   =>  [:get_backup_photos, :get_stream_media], 
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
      self.send(meth).each {|res| add_events(res)}
    end
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
    if p = @member.profile
      p.timeline(@start_date, @end_date).values
    end
  end
  
  def get_facebook_items
    ActivityStreamItem.facebook.between(@start_date, @end_date)
  end
  
  def get_twitter_items
    ActivityStreamItem.twitter.between(@start_date, @end_date)
  end
  
  def get_stream_media
    ActivityStreamItem.attachments.between(@start_date, @end_date)
  end
  
  def get_backup_photos
    facebook_source.backup_photo_albums.photos_in_dates(@start_date, @end_date).all.map(&:backup_photos).flatten.map(&:photo)
  end
  
  def get_emails
    returning Array.new do |emails|
      @member.backup_sources.by_site(BackupSite::Gmail).each do |gmail|
        emails << gmail.backup_emails.between(@start_date, @end_date)
      end
      emails.flatten
    end
  end
  
  def get_feed_items
    returning Array.new do |items|
      @member.backup_sources.by_site(BackupSite::Blog).each do |feed|
        items << feed.feed.entries.between(@start_date, @end_date)
      end
      items.flatten
    end
  end
  
  protected
  
  def facebook_source
    @facebook_source ||= @member.backup_sources.by_site(BackupSite::Facebook).first
  end
  
  def add_events(*evts)
    evts.flatten.each do |res|
      @events << TimelineEvent.new(res) if res
    end
  end
end

class TimelineSearchFaker < TimelineSearch
  def initialize(user_id, dates, options={})
    require 'benchmark_helper'
    require 'random_data'
    super(user_id, dates, options)
    @methods = search_methods.reject { |t| t == :get_profile }
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
  def get_backup_photos
    BackupPhoto.all.rand.photo
  end
  
  def get_emails
    GmailAccount.all.rand.backup_emails.rand
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
    if p = Profile.all.rand
      p.timeline(@start_date, @end_date).values
    end
  end 
end