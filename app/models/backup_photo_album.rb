# $Id$

class BackupPhotoAlbum < ActiveRecord::Base
  belongs_to :backup_source
  has_many :backup_photos, :dependent => :destroy do
    def import(photo)
      create({:source_photo_id => photo.id}.merge(photo.to_h))
    end
  end
  
  validates_presence_of :backup_source
  
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
    album.modified > self.modified
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
    
    # Get existing album photo source ids
    photo_ids = backup_photos.map(&:source_photo_id)
    
    # Add all new photos
    photos.each do |p|
      next if photo_ids.include? p.id
      backup_photos.import p
    end
    # Delete old photos
    photo_ids.each do |pid|
      p.destroy unless photos.map(&:id).include? pid
    end
  end
end