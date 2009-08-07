# $Id$
#
# Class that implements logic for searching a member's data to populate the Timeline

class TimelineSearch
  cattr_reader :max_results, :type_action_map
  @@max_results = 50
  @@type_action_map = {
    :email      => :get_emails,
    :twitter    => :get_activity_stream_items,
    :facebook   => :get_activity_stream_items,
    :artifacts  => [:get_backup_photos],
    :blog       => :get_feed_items,
    :profile    => :get_profile
  }
  
  def initialize(user_id, dates, options={})
    @member = Member.find(user_id)
    @start_date, @end_date = dates
    @options = options
    @events = []
  end
  
  def allowed_types
    actions = if @options[:type]
      @options[:type].split('|').map {|t| type_action_map[t.to_sym]}
    else
      type_action_map.values
    end
    actions.flatten.uniq
  end
  
  def results
    # do search 
    allowed_types.each do |meth|
      self.send(meth).each {|res| add_events(res)}
    end
    @events
  end
  
  def num_results
    @options[:empty] ? 0 : (@options[:max_results] || max_results).to_i
  end
  
  def get_profile
    @member.profile.timeline(@start_date, @end_date).values
  end
  
  # Returns random activity
  def get_activity_stream_items
    @member.activity_stream.items.between(@start_date, @end_date)
  end
  
  # Returns random photo from random album
  def get_backup_photos
    facebook_source.backup_photo_albums.photos_in_dates(@start_date, @end_date)
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
    @member = Member.by_name('TESTDUDE').first || Member.find(user_id)
  end
  
  def results
    add_events pick_random_result until @events.size >= num_results
    add_events get_profile
    #set_dates
    @events
  end
  
  def set_dates
    min = Date.parse @start_date
    max = Date.parse @end_date
    dates = min..max
    # Assign random date within range to each result
    BenchmarkHelper.rails_log('TimelineSearchFaker set random dates') do
      # Random.date_between takes foreeevvveeeerrr...
      # Using my own faster way
      @events.map! {|e| e.start_date = dates.first + rand(dates.count)}
    end
  end
  
  def pick_random_result
    self.send(allowed_types.rand)
  end
  
  # Returns random activity
  def get_activity_stream_items
    ActivityStream.all.rand.items.rand
  end
  
  # Returns random photo from random album
  def get_backup_photos
    BackupPhotoAlbum.all.rand
  end
  
  def get_emails
    GmailAccount.all.rand.backup_emails.rand
  end
  
  def get_feed_items
    FeedEntry.all.rand
  end
end