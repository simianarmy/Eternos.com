# $Id$

# ActivityStreamItem STI base class

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream
  
  # Creates object from a ActivityStreamProxy instance
  def self.create_from_proxy(item)
    create!(
      :guid             => item.id,
      :edited_at        => Time.at(item.updated),
      :published_at     => Time.at(item.created),
      :message          => item.message,
      :activity_type    => item.type,
      :attachment_data  => item.attachment_data,
      :attachment_type  => item.attachment_type)
  end
  
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  named_scope :latest, lambda { |num|
    {
      :order => 'published_at DESC', :limit => num || 1
    }
  }
  
  def to_timeline_event
    { :searchClass => search_class,
      :title => "",
      :caption => "",
      :summary => "",
      :time => "",
      :previewImgUrl => "",
      :data=> ""}
  end

private
  def search_class
    type.sub("ActivityStreamItem","").downcase
  end
end

# STI class children

class FacebookActivityStreamItem < ActivityStreamItem; end
class TwitterActivityStreamItem < ActivityStreamItem; end
