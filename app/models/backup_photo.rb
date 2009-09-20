# $Id$

class BackupPhoto < ActiveRecord::Base
  belongs_to :backup_photo_album
  belongs_to :photo, :class_name => 'Content', :foreign_key => 'content_id', :dependent => :destroy
  
  validates_presence_of :source_url
  validates_uniqueness_of :source_photo_id, :scope => :backup_photo_album_id
  
  serialize :tags
  xss_terminate :except => [ :tags ]
  acts_as_archivable :on => :created_at
  acts_as_state_machine :initial => :pending_download
  
  include TimelineEvents
  serialize_with_options do
    methods :start_date
  end
  
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
  
  named_scope :needs_download, :conditions => { :state => ['pending_download', 'failed_download'] }
  
  named_scope :between_dates, lambda { |start_date, end_date|
    {
      :conditions => {:created_at => start_date..end_date}
    }
  }
  named_scope :belonging_to_source, lambda { |id| 
    {
      :joins => :backup_photo_album,
      :conditions => ['backup_photo_albums.backup_source_id = ?', id]
    }
  }
  named_scope :with_photo, {
    :include => :photo
  }
  EditableAttributes = [:caption, :source_url, :tags]
  
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
      @filename = File.join(Dir::tmpdir, URI::parse(source_url).path.split('/').last)
      logger.info "Downloading #{source_url} to #{@filename}..."

      t = rio(@filename) < rio(source_url) # Download to temp file
      if t.bytes > 0
        c = Photo.create!(
          :owner => @member,
          :content_type => Content.detect_mimetype(@filename),
          :description => caption,
          :filename => File.basename(@filename),
          :temp_path => File.new(@filename))
        c.tag_with(tags.join(','), @member) if tags
        self.photo = c
      end
    rescue
      update_attribute(:download_error, $!)
    ensure
      rio(@filename).delete if @filename && File.exist?(@filename)
    end
  end

end
