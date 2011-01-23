# Copy of Facebooker::MessageThread class modified for BackupSource use

class FacebookThread < ActiveRecord::Base
  belongs_to :facebook_account
  belongs_to :parent_thread, :foreign_key => 'thread_id', :class_name => 'FacebookThread'
  has_many :messages, :class_name => 'FacebookMessage', :dependent => :destroy
  
  serialize :recipients
  validates_presence_of :facebook_account_id, :message_thread_id
  
  # Creates thread and associated messages from FacebookMessageThread data
  def self.save_thread!(account_id, message_thread)
    Rails.logger.debug "Creating thread from: #{message_thread.inspect}"
    # Create the thread object
    thread = self.create!({:message_thread_id => message_thread.id, 
      :facebook_account_id => account_id,
      :recipients => message_thread.recipients
      }.merge(build_attributes_from_proxy(message_thread)))
    Rails.logger.debug "Created thread = #{thread.inspect}"
    thread.sync_messages(message_thread.messages)
    thread
  end
  
  def self.build_attributes_from_proxy(message_thread)
    {:folder_id           => message_thread.folder_id,
      :parent_thread_id   => message_thread.parent_thread_id.to_i,
      :parent_message_id  => message_thread.parent_message_id.to_s,
      :fb_object_id       => message_thread.fb_object_id,
      :subject            => message_thread.subject,
      :unread             => message_thread.unread,
      :last_message_at    => message_thread.updated_at
    }
  end
  
  def build_attributes_from_proxy(message_thread)
    self.class.build_attributes_from_proxy(message_thread)
  end
  
  # Takes Facebooker::MessageThread object
  # Determines if the thread has been modified since last saved
  def modified?(message_thread)
    (message_count != message_thread.message_count.to_i) ||
    (last_message_at != message_thread.updated_at)
  end
  
  # Syncs thread and associated messages with FacebookMessageThread data
  def sync_thread(message_thread)
    Rails.logger.debug "Synching thread: #{message_thread_id} with #{message_thread.inspect}"
    # Sync thread attributes 
    update_attributes(build_attributes_from_proxy(message_thread))
    if self.recipients != message_thread.recipients
      update_attribute(:recipients, message_thread.recipients)
    end
    # Sync messages
    sync_messages(message_thread.messages)
  end
  
  def sync_messages(thread_messages)
    Rails.logger.debug "In sync_messages"
    # Get list of existing ids, only create those that are new
    existing_ids = messages.map(&:message_id)
    Rails.logger.debug "Existing messages: #{existing_ids.inspect}"
    thread_messages.each do |msg|
      Rails.logger.debug "Checking message: #{msg.message_id}"
      unless existing_ids.include?(msg.message_id.to_s)
        self.messages << FacebookMessage.build_from_proxy(msg)
      end
    end
  end
  
  protected
  
end