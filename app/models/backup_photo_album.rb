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
    self.create(
      {:backup_source => source, :source_album_id => album.id}.merge(album.to_h)
    )
  end
  
  def self.db_attributes
    EditableAttributes
  end
  
  # Checks passed album object for differences with this instance
  def modified?(album)
    return !album.modified.blank? if self.modified.nil?
    (album.modified.to_i > self.modified.to_i) || (album.size.to_i != self.size)
  end
  
  # Save album properies & any associated photos
  def save_album(album, photos=nil)
    if update_attributes(album.to_h)
      save_photos(photos) if photos
    end
  end
  
  # Saves any new photos in album
  def save_photos(photos)
    return unless photos && photos.any?
    new_photo_ids = photos.map(&:id)
    existing_photo_ids = backup_photos.map(&:source_photo_id)
    
    # Delete old photos
    backup_photos.each do |p|
      p.destroy unless new_photo_ids.include? p.source_photo_id
    end
    
    # Add all new photos
    photos.each do |p|
      next if existing_photo_ids.include? p.id
      backup_photos.import p
    end
  end

  def to_s
    "#{source_album_id} : #{name} : #{description}"
  end
end
