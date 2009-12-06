# $Id$

class BackupPhoto < ActiveRecord::Base
  include AfterCommit::ActiveRecord
  
  belongs_to :backup_photo_album
  belongs_to :photo, :class_name => 'Content', :foreign_key => 'content_id', :dependent => :destroy
  
  validates_presence_of :source_url
  validates_uniqueness_of :source_photo_id, :scope => :backup_photo_album_id
  
  serialize :tags
  xss_terminate :except => [ :tags ]
  acts_as_archivable :on => :added_at
  acts_as_state_machine :initial => :pending_download
  
  include TimelineEvents
  
  state :pending_download
  state :downloading, :enter => :download
  state :downloaded
  state :failed_download
  
  event :starting_download do
    transitions :from => [:pending_download, :failed_download], :to => :downloading
  end
  
  event :download_complete do
    transitions :from => :downloading, :to => :downloaded
  end
  
  event :download_error do
    transitions :from => [:downloading, :downloaded], :to => :failed_download
  end
  
  include CommonDateScopes
  named_scope :needs_download, :conditions => { :state => ['pending_download', 'failed_download'] }
  named_scope :belonging_to_source, lambda { |id| 
    {
      :joins => :backup_photo_album,
      :conditions => ['backup_photo_albums.backup_source_id = ?', id]
    }
  }
  named_scope :include_content, :include => :photo
  
  named_scope :with_photo, {
    :include => {:photo => :thumbnails}
  }
  EditableAttributes = [:caption, :title, :added_at, :source_url, :tags]
  
  def self.db_attributes
    EditableAttributes
  end
  
  def bytes
    photo ? photo.size : 0
  end
  
  # Downloads from source & create new Content object with data
  # Returns photo object on success
  def download
    return unless source_url

    begin
      # Sanity check
      @member = backup_photo_album.backup_source.member
      @filename = File.join(AppConfig.s3_staging_dir, URI::parse(source_url).path.split('/').last)
      logger.debug "Downloading #{source_url} to #{@filename}..."

      @img = rio(@filename)
      rio(source_url).binmode > @img

      raise "Rio error saving #{source_url} to #{@filename}" unless @img.size?

      self.photo = Photo.create!(
      :owner => @member,
      :content_type => Content.detect_mimetype(@filename),
      :description => caption,
      :filename => File.basename(@filename),
      :temp_path => File.new(@filename),
      :tag_list => tags || '',
      :taken_at => added_at,
      :collection => backup_photo_album)
      save!
    rescue
      update_attribute(:download_error, $!)
    ensure
      @img.delete if @img && @img.exist?
    end
  end

  protected
  
  def after_commit_on_create
    logger.debug "Sending job to image download worker: #{self.id}"
    ImageDownloadWorker.async_download_image(:id => self.id)
  end
end
