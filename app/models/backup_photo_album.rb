# $Id$

class BackupPhotoAlbum < ActiveRecord::Base
  belongs_to :backup_source
  
  validates_presence_of :backup_source
  
  EditableAttributes = [:cover_id, :size, :name, :description, :location, :modified]
  
  def self.import(source, album)
    self.create(
      :backup_source => source,
      :source_album_id => album.id, 
      :cover_id => album.cover_id, 
      :size => album.size, 
      :name => album.name, 
      :description => album.description, 
      :location => album.location,
      :modified => album.modified
    )
  end
  
  # Checks passed album object for differences with this instance
  def modified?(album)
    return !album.modified.blank? if self.modified.nil?
    album.modified > self.modified
  end
  
  # Updates album attributes from passed album
  def modify(album)
    EditableAttributes.each { |attr| self[attr] = album.send(attr) }
    save
  end
end
