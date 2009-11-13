# $Id$

class BackupPhotoAlbum < ActiveRecord::Base
  belongs_to :backup_source
  has_many :backup_photos, :dependent => :destroy do
    def import(photo)
      create({:source_photo_id => photo.id.to_s}.merge(photo.to_h))
    end
  end
  
  validates_presence_of :backup_source
  validates_uniqueness_of :source_album_id, :scope => :backup_source_id
  
  alias_method :photos, :backup_photos
  
  serialize_with_options(:gallery) do
    methods :cover_photo_url
    except :id, :backup_source_id, :source_album_id, :cover_id
    # Because serialize_with_options only supports 1 level of nesting, we have 
    # to specify the attributes to exclude manually in the include hash - booo
    includes :backup_photos => {
      :except => [:id, :tags, :source_url, :backup_photo_album_id, :source_photo_id, :content_id, :created_at,
        :updated_at, :state, :download_error, :added_at],
      :include => { :photo => { 
        :methods => [:url, :thumbnail],
        :except => [:id, :size, :type, :filename, :thumbnail, :bitrate, :created_at, 
          :updated_at, :user_id, :content_type, :duration, :version, :processing_error_message,
          :fps, :state, :is_recording, :s3_key] 
      } } }
  end
  
  # Returns photo ids of photos in album within arg dates
  named_scope :photos_between_dates, lambda { |s, e| 
    {
      #:include => { :backup_photos => :photo },
      :joins => 'backup_photos',
      :conditions => {'backup_photos.created_at' => s..e},
      :select => 'backup_photos.id'
    }
  }
  EditableAttributes = [:cover_id, :size, :name, :description, :location, :modified]
  
  def self.import(source, album)
    self.create!(
      {:backup_source => source, :source_album_id => album.id}.merge(album.to_h)
    )
  end
  
  def self.db_attributes
    EditableAttributes
  end
  
  def cover_photo
    # Try to avoid using invalid photos if there are multiple backup photos with the 
    # same source photo id
    BackupPhoto.find_all_by_source_photo_id(cover_id).map(&:photo).compact.first
  end
  
  def cover_photo_url
    cover_photo.url rescue nil
  end
  
  # Checks passed album object for differences with this instance
  def modified?(album)
    return !album.modified.blank? if self.modified.nil?
    (album.modified.to_i > self.modified.to_i) || (album.size.to_i != self.size)
  end
  
  # Save album properies & any associated photos
  def save_album(album, new_photos=nil)
    if update_attributes(album.to_h)
      save_photos(new_photos) if new_photos
    end
  end
  
  # Saves any new photos in album
  def save_photos(new_photos)
    return unless new_photos && new_photos.any?
    new_photo_ids = new_photos.map(&:id)
    existing_photo_ids = backup_photos.map(&:source_photo_id)
    
    # Delete old photos
    backup_photos.each do |p|
      p.destroy unless new_photo_ids.include? p.source_photo_id
    end
    
    # Add all new photos
    new_photos.each do |p|
      next if existing_photo_ids.include? p.id
      backup_photos.import p
    end
  end

  def to_s
    "#{source_album_id} : #{name} : #{description}"
  end
end
