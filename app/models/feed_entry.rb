# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed_url
  validates_uniqueness_of :guid, :scope => :feed_url_id
  
  def self.add_entries(feed_id, entries)
      entries.each do |entry|
        unless exists? :guid => entry.id
          create!(
            :feed_url_id  => feed_id,
            :name         => entry.title,
            :summary      => entry.summary,
            :url          => entry.url,
            :published_at => entry.published,
            :guid         => entry.id
          )
        end
      end
    end
  end
end
