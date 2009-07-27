# $Id$

require 'tmail'

class BackupEmail < ActiveRecord::Base
  belongs_to :backup_source
  
  validates_presence_of :mailbox
  validates_presence_of :message_id
  validates_uniqueness_of :message_id, :scope => [:backup_source_id, :mailbox]
  
  attr_reader :raw_email
  serialize :sender
  alias_attribute :bytes, :size
  
  before_create :cb_after_create_save_contents
  before_destroy :cb_before_destroy_delete_contents
  
  named_scope :latest, lambda { |num|
    {
      :order => 'received_at DESC', :limit => num || 1
    }
  }
  # Parses raw email string to extract email attributes & contents
  # Catch exceptions from mail parsing or file saving io
  def email=(raw_email)
    begin
      e = TMail::Mail.parse(raw_email)
      self.subject      = e.subject
      self.sender       = e.from
      self.received_at  = e.date
      # Save email for save_contents callback
      rio(temp_filename) < raw_email
    rescue
      errors.add_to_base("Unexpected error in email=: " + $!)
    end
  end

  # Fetch from S3
  def raw
    S3Downloader.new(:email).fetch_value(s3_key)
  end
  
  def body
    TMail::Mail.parse(raw).body rescue nil
  end
  
  private
  
  def gen_s3_key
    [mailbox.gsub(/\//, '_'), message_id, backup_source_id].join(':')
  end
  
  # Send id to upload worker queue
  def cb_after_create_save_contents
    UploadsWorker.async_upload_content_to_cloud(:id => self.id)
    unless @raw_email
      errors.add_to_base("missing raw_email attribute")
      return false
    end
    key = gen_s3_key
    if S3Uploader.new(:email).store(key, @raw_email)
      self.s3_key = key
      self.size = @raw_email.length
    else
      errors.add_to_base("S3 upload failed for key: #{s3_key}")
      false
    end
  end
  
  # Deletes email from s3 before destroy
  def cb_before_destroy_delete_contents
    S3Connection.new(:email).bucket.delete s3_key
  end
  
end
