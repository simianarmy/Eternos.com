# $Id$

# STI class

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream # Not until 2.3.2 :touch => :last_activity_at
  
  serialize :attachment_data
  xss_terminate :except => [ :attachment_data ]
  
  named_scope :latest, :order => "created_at DESC", :limit => 1
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  
  # Need this until 2.3.2
  after_update :update_parent_last_activity_time
  
  # Creates object from a ActivityStreamProxy instance
  def self.create_from_proxy(item)
    create!(
      :guid       => item.id,
      :created_at => item.created,
      :updated_at => item.updated,
      :published_on => Time.at(item.created),
      :message => item.message,
      :activity_type => item.type,
      :attachment_data => item.attachment_data,
      :attachment_type => item.attachment_type)
  end
  
  private
  
  def update_parent_last_activity_time
    if activity_stream.last_activity_at.nil? or activity_stream.last_activity_at < (@time = Time.now)
      activity_stream.update_attribute(:last_activity_at, @time) 
    end
    true
  end
end

# STI children

class FacebookActivityStreamItem < ActivityStreamItem; end
class TwitterActivityStreamItem < ActivityStreamItem; end