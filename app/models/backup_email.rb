# $Id$

require 'tmail'

class BackupEmail < ActiveRecord::Base
  include AfterCommit::ActiveRecord
  
  belongs_to :backup_source
  
  validates_presence_of :mailbox
  validates_presence_of :message_id
  validates_uniqueness_of :message_id, :scope => [:backup_source_id, :mailbox]
  
  attr_reader :raw_email
  serialize :sender
  alias_attribute :bytes, :size
  
  before_destroy :before_destroy_delete_contents
  
  named_scope :latest, lambda { |num|
    {
      :order => 'received_at DESC', :limit => num || 1
    }
  }
  
  # Send id to upload worker queue
  def after_commit_on_create
    UploadsWorker.async_upload_email_to_cloud(:id => self.id)
  end
  
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
    @raw_email ||= S3Downloader.new(:email).fetch_value(s3_key)
  end
  
  def body
    @body ||= TMail::Mail.parse(raw).body if raw
  end
  
  def gen_s3_key
    [mailbox.gsub(/\//, '_'), message_id, backup_source_id].join(':')
  end
  
  # checks if email saved to cloud without actually checking cloud fs
  def uploaded?
    s3_key && (s3_key == gen_s3_key) && (size > 0)
  end
  
  # Returns full path to tempfile containing raw email contents
  # Required to store on disk while waiting for asynchronous upload to cloud
  def temp_filename
    File.join(AppConfig.s3_staging_dir, [self.message_id, self.backup_source_id].join(':') + '.email')
  end
    
  private
  
  # Deletes email from s3 before destroy
  def before_destroy_delete_contents
    S3Connection.new(:email).bucket.delete s3_key
  end
  
end
