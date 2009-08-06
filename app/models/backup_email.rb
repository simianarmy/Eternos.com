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

  acts_as_archivable :on => :received_at
  acts_as_state_machine :initial => :pending_upload
  
  state :pending_upload
  state :uploaded
  state :error
  
  event :uploaded do
    transitions :from => :pending_upload, :to => :uploaded
  end
  
  event :upload_error do
    transitions :from => :pending_upload, :to => :error
  end
  
  before_destroy :before_destroy_delete_contents
  
  named_scope :latest, lambda { |num|
    {
      :order => 'received_at DESC', :limit => num || 1
    }
  }

  # Send id to upload worker queue
  def after_commit_on_create
    #MessageQueue.email_upload_queue.publish({:id => self.id}.to_json)
    #logger.debug "Sent backup email #{self.id} to upload queue"
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
 
  # Returns full path to tempfile containing raw email contents
  # Required to store on disk while waiting for asynchronous upload to cloud
  def temp_filename
    File.join(AppConfig.s3_staging_dir, [self.message_id, self.backup_source_id].join(':') + '.email')
  end
    
  # Called by batch uploader to reuse s3 connection
  # Takes already created S3Uploader object
  # Returns true on success
  def upload_to_s3(s3)
    # do some validity checks
    if uploaded?
      logger.warn "email #{id} already uploaded"
      return
    end
    email_file = temp_filename
    unless File.exists?(email_file)
      logger.warn "missing raw file (#{email_file}) for email #{id}"
      return
    end
    
    begin
      key = gen_s3_key
      mark = Benchmark.realtime do
        if s3.upload(email_file, key)
          uploaded!
          update_attributes(:s3_key => key, :size => File.size(email_file))
          FileUtils.rm email_file
        end
      end
      logger.debug "Uploaded email in #{mark} seconds"
    rescue
      logger.error "error uploading email to cloud: " + $!.to_s
      upload_error!
      update_attribute(:upload_errors, $!.to_s)
      raise
    end
  end
  
  private
  
  # Deletes email from s3 before destroy
  def before_destroy_delete_contents
    S3Connection.new(:email).bucket.delete s3_key
  end
  
end
