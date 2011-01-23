# Facebook Thread Message class

class FacebookMessage < ActiveRecord::Base
  belongs_to :facebook_thread, :counter_cache => 'message_count'
  belongs_to :facebook_account
  belongs_to :owner, :class_name => 'Member'
  
  serialize :attachment
  
  validates_presence_of :message_id, :author_id
  
  # Builds new object from Facebooker::MessageThread::Message object
  # TODO: Convert it to a proxy object before passing
  def self.build_from_proxy(message)
    self.new(:message_id => message.message_id.to_s,
      :author_id  => message.author_id,
      :body       => message.body,
      :attachment => message.attachment,
      :created_at => Time.at(message.created_time.to_i)
    )
  end
end