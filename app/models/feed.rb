# $Id$

require 'feedzirra'

class Feed < ActiveRecord::Base
  belongs_to :feed_url, :foreign_key => 'backup_source_id'
  has_many :entries, :class_name => 'FeedEntry' do
    def add(entry)
      create!(:name   => entry.title,
        :summary      => entry.summary,
        :content      => entry.content,
        :url          => entry.url,
        :published_at => entry.published,
        :guid         => entry.id,
        :categories   => entry.categories)
    end
  end
  
  # Takes optional feed object
  def update_from_feed(auth_feed=nil)
    # If there are existing entries, then create a feed 
    # object using the most recent entry's data so that we can use Feedzirra's update
    # method to save bandwidth,cpu
    # TODO:
    # As noted on Railscasts - update does not work!?!
    # For now do brute force fetch & parse every time...hopefully jackass will 
    # have fixed his shit by the time this needs to be optimized.
    
    #if entries.any?
    #  feed = Feedzirra::Feed.update(create_feed_for_update)
    #  add_entries(feed.new_entries) if feed.updated?
    #else
      feed = auth_feed || Feedzirra::Feed.fetch_and_parse(feed_url_s)
      add_entries(feed.entries) if feed
    #end
    update_attributes(:etag => feed.etag, :last_modified => feed.last_modified)
  end
  
  # Add all unsaved feed entries
  def add_entries(feed_entries)
    guids = entries.map(&:guid)
    feed_entries.reject {|e| guids.include? e.id}.each do |entry|
      entry.sanitize!
      entries.add(entry)
    end
  end
  
  private
  
  def create_feed_for_update
    # Should not matter what kind of Parser we use
    returning Feedzirra::Parser::RSS.new do |feed|
      feed.etag = self.etag
      feed.last_modified = self.last_modified
      feed.feed_url = self.feed_url_s
    end
  end
end
