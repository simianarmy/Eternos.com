# $Id$
#
# Class that implements logic for searching a member's data to populate the Timeline

class TimelineSearch
  MaxResults = 50
  
  def initialize(user_id, dates, options={})
    @member = Member.find(user_id)
    @start_date, @end_date = dates
    @options = options
    @events = []
  end
  
  def results
    # do search 
    [:get_profile, :get_activity_stream_items, :get_backup_photos, :get_emails, :get_feed_items].each do |meth|
      self.send(meth).each {|res| add_events(res)}
    end
    @events
  end
  
  def num_results
    @options[:empty] ? 0 : (@options[:max_result] || MaxResults).to_i
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
    require 'random_data'
    super(user_id, dates, options)
    @member = Member.by_name('TESTDUDE').first || Member.find(user_id)
  end
  
  def results
    until @events.size >= num_results
      add_events pick_random_result
    end
    add_events get_profile
    min = Date.parse @start_date
    max = Date.parse @end_date
    # Assign random date within range to each result
    @events.map {|e| e.start_date = Random.date_between(min..max) }
    @events.uniq
  end
  
  
  def pick_random_result
    self.send([:get_activity_stream_item, :get_backup_photo, :get_email, :get_feed_item].rand)
  end
  
  # Returns random activity
  def get_activity_stream_item
    ActivityStream.all.rand.items.rand
  end
  
  # Returns random photo from random album
  def get_backup_photo
    BackupPhotoAlbum.all.rand
  end
  
  def get_email
    GmailAccount.all.rand.backup_emails.rand
  end
  
  def get_feed_item
    FeedEntry.all.rand
  end
end