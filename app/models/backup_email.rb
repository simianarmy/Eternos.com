# $Id$

require 'tmail'
require 'ezcrypto'
require 'singleton'
require 'attr_encrypted'

class BackupEmail < ActiveRecord::Base
  class EncryptionError < Exception; end
  belongs_to :backup_source
  has_one :member, :through => :backup_source
  
  validates_presence_of :mailbox
  validates_presence_of :message_id
  validates_uniqueness_of :message_id, :scope => [:backup_source_id, :mailbox], :message => "message id already saved"
  
  attr_reader :raw_email
  alias_attribute :bytes, :size
  
  # The new encryption with attr_encrypted gem
  # Using suffix & encode options in order to decode existing Lucifer-encrypted values
  attr_encrypted :subject, :prefix => '', :suffix => '_encrypted', :key => 'i am a key', 
    :encryptor => Eternos::Encryptor, :encode => false
  # The old encryption with lucifer plugin
  #encrypt_attributes :suffix => '_encrypted'
  
  acts_as_archivable :on => :received_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include TimelineEvents
  include CloudStaging
  serialize :sender
      
  # serialize_with_options do
  #     only :id, :sender
  #     methods :start_date, :subject
  #   end
  acts_as_saved_to_cloud
  
  before_destroy :delete_s3_contents
  
  include CommonDateScopes
  
  named_scope :belonging_to_user, lambda { |id| 
      {
        :joins => :backup_source,
        :conditions => ['backup_sources.user_id = ?', id]
      }
  }
  named_scope :message_ids, :select => 'message_id'
  
  # don't use until searchlogic 2.3.2+
  # scope_procedure :belonging_to_user, lambda { |user_id| 
  #     backup_source_user_id_eq(user_id)
  #   }
  
  # thinking_sphinx - incomplete solution since we cannot index encrypted columns
  define_index do
    # fields
    indexes sender
    indexes tags(:name), :as => :tags
    
    # attributes
    has backup_source_id, received_at, created_at
    
    where "deleted_at IS NULL"
  end

  # Required to handle subject.to_json exceptions when subject cannot be decrypted
  # and returns a binary byte string which causes JSON to blork
  def as_json(options={})
    res = {:id => id, :sender => sender, :start_date => start_date, :subject => subject}
    begin
      res.as_json(options)
    rescue JSON::GeneratorError
      res[:subject] = 'Could not decrypt subject!'
      res.as_json(options)
    end
  end
  
  # Parses raw email string to extract email attributes & contents
  # Catch exceptions from mail parsing or file saving io
  def email=(raw_email)
    begin
      e = TMail::Mail.parse(raw_email)
      self.subject      = e.subject
      self.sender       = e.from
      self.received_at  = e.date
      # Encrypt and save email to disk file for async S3 upload job
      # Email content should only be unencrypted while in RAM (except for subject)
      logger.debug "Saving encrypted email to #{temp_filename}"
      raise EncryptionError.new("Email encryption failed") unless encrypted = encrypt(raw_email)
      rio(temp_filename) < encrypted
    rescue
      logger.debug "Unexpected error in #{self.class}.email=: " + $!
      errors.add_to_base("Unexpected error in email=: " + $!)
    end
  end

  # Fetch from S3
  def raw
    @raw_email ||= decrypt(S3Downloader.new(:email).fetch_value(s3_key))
  end
  
  def body
    @body ||= TMail::Mail.parse(raw).body if raw
  end
  
  def recipient
    backup_source.email
  end
  
  def gen_s3_key
    [mailbox.gsub(/\//, '_'), message_id, backup_source_id].join(':')
  end
 
  # Returns full path to tempfile containing raw email contents
  # Required to store on disk while waiting for asynchronous upload to cloud
  def temp_filename
    File.join(cloud_staging_dir, [self.message_id, self.backup_source_id].join(':') + '.email')
  end
    
  # Called on after_commit to send uploading job to asynchronous queue
  def upload
    EmailsWorker.async_process_backup_email(:id => self.id)
  end
  
  def uploaded?
    !!self.s3_key
  end
  
  # Called by asynchronous worker to do actual job of saving to S3
  def upload_to_s3(s3)
    # do some validity checks
    if uploaded?
      logger.warn "email #{id} already uploaded"
      return
    end
    email_file = temp_filename
    raise "missing raw file (#{email_file}) for email #{id}" unless File.exist?(email_file)

    key = gen_s3_key
    if s3.upload(email_file, key)
      update_attributes(:s3_key => key, :size => File.size(email_file))
      FileUtils.rm email_file # Delete file from disk
    end    
  end
  
  # Encrypts email passed to it in plain-text and returns it in encrypted Base64 encoded form. 
  def encrypt(data)
    crypto_key.encrypt64(data)
  end
  
  # Decrypts email passed to it as base64 formatted string
  def decrypt(data)
    crypto_key.decrypt64(data)
  end
  
  private
  
  class EmailEncryptionKey
    require 'app_setting'
    include Singleton
    @key = nil
    attr_reader :key
    
    def initialize
      @key = EzCrypto::Key.new AppSetting.first.master
    end
  end
  
  # Deletes email from s3 before destroy
  def delete_s3_contents
    S3Connection.new(:email).bucket.delete self.s3_key if self.uploaded?
  end
  
  # Helper to generate symmetric key for encryption
  def crypto_key
    # Returns singleton object
    EmailEncryptionKey.instance.key
  end
end
