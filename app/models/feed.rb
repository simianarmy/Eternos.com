# $Id$

class Feed < ActiveRecord::Base
  belongs_to :feed_url, :foreign_key => 'backup_source_id'
  has_many :entries, :class_name => 'FeedEntry' do
    def add(entry)
      create!(
        :author       => entry.author,
        :name         => entry.title,
        :summary      => entry.summary,
        :rss_content      => entry.content,
        :url          => entry.url,
        :published_at => entry.published,
        :guid         => entry.id,
        :categories   => entry.categories)
    end
  end
  
  # Takes optional feed object
  def update_from_feed(auth_feed=nil)
    # If there are existing entries, then create a feed 
    # object using the most recent entry's data and use Feedzirra's update method
    # to only fetch those new entries
    if entries.any?
      feed = Feedzirra::Feed.update(create_feed_for_update)
      add_entries(feed.new_entries) if valid_parse_result(feed) && feed.updated?
    else
      # Fetch whole feed (may not be entire feed - depends on source)
      feed = auth_feed || Feedzirra::Feed.fetch_and_parse(feed_url_s)
      # Can return error status code on parse error
      add_entries(feed.entries) if valid_parse_result(feed)
    end
    # Save latest feed attributes for updates
    update_attributes(:etag => feed.etag, :last_modified => feed.last_modified, :feed_url_s => feed.feed_url) if valid_parse_result(feed)
  end
  
  # Add all unsaved feed entries
  def add_entries(feed_entries)
    guids = entries.map(&:guid)
    feed_entries.reject {|e| guids.include? e.id}.each do |entry|
      entry.sanitize!
      entries.add(entry)
    end
  end
  
  def valid_parse_result(feed)
    !(feed.nil? || feed.kind_of?(Fixnum))
  end
  
  private
  
  def create_feed_for_update
    # Should not matter what kind of Parser we use
    returning Feedzirra::Parser::Atom.new do |feed|
      feed.etag           = etag
      feed.last_modified  = last_modified
      feed.feed_url       = feed_url_s
      
      last_entry     = Feedzirra::Parser::AtomEntry.new
      last_entry.url = entries.latest.first.url
      
      feed.entries = [last_entry]
    end
  end
end
