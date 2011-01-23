# Facebook Thread Message class

class FacebookMessage < ActiveRecord::Base
  belongs_to :facebook_thread, :counter_cache => 'message_count'
  
  serialize :attachment
  
  validates_presence_of :message_id, :author_id
  
  # thinking_sphinx
  define_index do
    indexes :body
    has created_at
  end
  
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