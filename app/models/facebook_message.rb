# Facebook Thread Message class

class FacebookMessage < ActiveRecord::Base
  belongs_to :facebook_thread, :counter_cache => 'message_count'
  belongs_to :facebook_account, :foreign_key => 'backup_source_id'
  serialize :attachment
  
  validates_presence_of :message_id, :author_id
  
  # thinking_sphinx
  # TODO: Add backup source foreign key so that we can search with attribute
  define_index do
    indexes :body
    has created_at, backup_source_id
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
end