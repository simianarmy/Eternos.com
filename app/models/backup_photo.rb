# $Id$

require 'rio'

class BackupPhoto < ActiveRecord::Base
  belongs_to :backup_photo_album
  belongs_to :photo, :foreign_key => 'content_id', :dependent => :destroy
  
  validates_presence_of :source_url
  validates_uniqueness_of :source_photo_id, :scope => :backup_photo_album_id
  
  serialize :tags
  xss_terminate :except => [ :tags ]
  acts_as_state_machine :initial => :pending_download
  
  state :pending_download
  state :downloading, :enter => :download
  state :downloaded
  state :error
  
  event :start_download do
    transitions :from => :pending_download, :to => :downloading
  end
  
  event :download_complete do
    transitions :from => :downloading, :to => :downloaded
  end
  
  event :download_error do
    transitions :from => :downloading, :to => :error
  end
  
  named_scope :needs_download, :conditions => { :state => 'pending_download' }
  
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
      logger.info "Downloading #{source_url} to #{filename}..."

      t = rio(@filename) < rio(source_url) # Download to temp file

      if t.bytes > 0
        @photo = Photo.create(
        :parent_id => id,
        :owner => @member,
        :content_type => Content.detect_mimetype(@filename),
        :description => caption,
        :filename => File.basename(@filename),
        :temp_path => File.new(@filename)) do |p|    
          p.tag_with(tags.join(','), @member) if tags
          update_attribute(:content_id, p.id)
        end
      end
    rescue
      update_attribute(:download_error, $!)
    ensure
      rio(@filename).delete if @filename && File.exist?(@filename)
    end
  end

end
