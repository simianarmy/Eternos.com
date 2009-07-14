# $Id$
#
# Class that implements logic for searching a member's data to populate the Timeline

class TimelineSearch
  def initialize(user_id, dates, options)
    debugger
    @options = options
    @events = []
    @member = Member.find(user_id)
  end
  
  def results
    # do search 
    @events
  end
end

class TimelineSearchFaker
  MaxResults = 10
  
  def initialize(user_id, dates, options)
    @options = options
    @member = Member.by_name('TIMELINE_TEST').first || Member.find(user_id)
    @facebook_source = @member.backup_sources.by_site(BackupSite::Facebook).first
  end
  
  def results
    returning Array.new do |results|
      num_results.times do 
        results << pick_random_result
      end
    end
  end
  
  def num_results
    @options[:empty] ? 0 : (@options[:max_result] || MaxResults)
  end
  
  def pick_random_result
    obj = self.send([:get_activity_stream_item, :get_backup_photo].rand)
    TimelineEvent.new(obj)
  end
  
  # Returns random activity
  def get_activity_stream_item
    @member.activity_stream.items.rand
  end
  
  # Returns random photo from random album
  def get_backup_photo
    @facebook_source.backup_photo_albums.rand.backup_photos.rand
  end
end