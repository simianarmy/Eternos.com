# $Id$

class ActivityStream < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :activity_stream_items
   
  # Takes collection of activity stream data and saves to db 
  def add_items(*items)
    self.activity_stream_items << items.flatten.map {|i| convert_stream_item_from_proxy(i)}
  end
  
  def latest_activity_time
    latest = activity_stream_items.newest
    latest.empty? ? nil : latest.first.created_at
  end
  
  private
  
  def convert_stream_item_from_proxy(item)
    case backup_site.name
    when :facebook
      FacebookActivityStreamItem.create_from_proxy(item)
    end
  end
end
