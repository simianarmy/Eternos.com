# Facebook Thread Message class

class FacebookMessage < ActiveRecord::Base
  belongs_to :facebook_thread, :counter_cache => 'message_count'
  belongs_to :facebook_account, :foreign_key => 'backup_source_id'
  has_one :member, :through => :facebook_account
  serialize :attachment
  
  validates_presence_of :message_id, :author_id
  
  acts_as_archivable :on => :created_at
  acts_as_taggable_on :tags
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include TimelineEvents
  include CommonDateScopes
  
  # thinking_sphinx
  # TODO: Add backup source foreign key so that we can search with attribute
  define_index do
    indexes :body
    has created_at, backup_source_id
  end
  
  serialize_with_options do
    methods :url, :thumbnail_url, :subject
  end
  
  # Builds new object from Facebooker::MessageThread::Message object
  # TODO: Convert it to a proxy object before passing
  def self.build_from_proxy(backup_source_id, message)
    self.new(:message_id  => message.message_id.to_s,
      :author_id          => message.author_id,
      :body               => message.body,
      :attachment         => message.attachment,
      :created_at         => Time.at(message.created_time.to_i),
      :backup_source_id   => backup_source_id
    )
  end
  
  def thumbnail_url
    if has_media?
      media.first['src']
    end
  end
  
  def url
    media.first['href'] if has_media?
  end
  
  def subject
    facebook_thread.subject
  end
  
  protected
  
  def parsed_attachment
  end
  
  def media
    attachment.try(:media)
  end
  
  def has_media?
    media && media.any?
  end
end