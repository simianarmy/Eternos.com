# $Id$

class ActivityStream < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :activity_stream_items
  
  def latest_activity_time
    latest = activity_stream_items.newest
    latest.empty? ? nil : latest.first.created_at
  end
  
end
