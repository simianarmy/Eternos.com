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

  acts_as_archivable :on => :received_at
  acts_as_saved_to_cloud
  
  before_destroy :delete_s3_contents
  
  named_scope :latest, lambda { |num|
    {
      :order => 'received_at DESC', :limit => num || 1
    }
  }
  named_scope :between_dates, lambda {|s, e| 
    { :conditions => ['DATE(received_at) BETWEEN ? AND ?', s, e] }
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
    @raw_email ||= S3Downloader.new(:email).fetch_value(s3_key)
  end
  
  def body
    @body ||= TMail::Mail.parse(raw).body if raw
  end
  
  def gen_s3_key
    [mailbox.gsub(/\//, '_'), message_id, backup_source_id].join(':')
  end
 
  # Returns full path to tempfile containing raw email contents
  # Required to store on disk while waiting for asynchronous upload to cloud
  def temp_filename
    File.join(AppConfig.s3_staging_dir, [self.message_id, self.backup_source_id].join(':') + '.email')
  end
    
  # Called on after_commit to send uploading job to asynchronous queue
  def upload
    EmailsWorker.async_process_backup_email(:id => self.id)
  end
  
  def uploaded?
    !s3_key.nil?
  end
  
  # Called by asynchronous worker to do actual job of saving to S3
  def upload_to_s3(s3)
    # do some validity checks
    if uploaded?
      logger.warn "email #{id} already uploaded"
      return
    end
    email_file = temp_filename
    unless File.exists?(email_file)
      cloud_upload_error "missing raw file (#{email_file}) for email #{id}"
      return
    end

    key = gen_s3_key
    if s3.upload(email_file, key)
      update_attributes(:s3_key => key, :size => File.size(email_file))
      FileUtils.rm email_file
    end    
  end
  
  private
  
  # Deletes email from s3 before destroy
  def delete_s3_contents
    S3Connection.new(:email).bucket.delete s3_key
  end
  
end
