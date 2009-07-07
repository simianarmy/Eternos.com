# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  validates_uniqueness_of :guid, :scope => :feed_id
  
  serialize :categories
  xss_terminate :except => [ :categories ]
  
  named_scope :latest, :order => 'published_at DESC', :limit => 1
end
