# $Id$

require 'tmail'

class BackupEmail < ActiveRecord::Base
  belongs_to :backup_source
  has_one :email_content
  
  validates_presence_of :message_id
  validates_uniqueness_of :message_id, :scope => :backup_source_id
  
  serialize :sender
  attr_writer :raw_email
  attr_reader :body
  
  delegate :bytes, :to => :email_content
  
  named_scope :latest, lambda { |num|
    {
      :order => 'received_at DESC', :limit => num || 1
    }
  }
  # Parses raw email string to extract email attributes & contents
  def email=(raw_email)
    if e = TMail::Mail.parse(raw_email)
      self.subject      = e.subject
      self.sender       = e.from
      self.received_at  = e.date
      self.email_content = EmailContent.new(:bytes => e.body.size, :contents => raw_email)
    end
  end
  
  def body
    TMail::Mail.parse(email_content.contents).body rescue nil
  end
  
  def size
    bytes
  end
end
