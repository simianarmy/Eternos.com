# $Id$

class FeedContent < ActiveRecord::Base
  belongs_to :feed_entry
end