# $Id$

class ActivityStream < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :items, :class_name => 'ActivityStreamItem'
  
  def latest_activity_time
    latest = items.newest
    latest.empty? ? nil : latest.first.created_at
  end
  
end
