# $Id$

require 'rio'

class BackupPhoto < ActiveRecord::Base
  belongs_to :backup_photo_album
  belongs_to :photo, :foreign_key => 'content_id', :dependent => :destroy
  
  validates_presence_of :source_url
  validates_uniqueness_of :source_photo_id, :scope => :backup_photo_album_id
  
  serialize :tags
  xss_terminate :except => [ :tags ]
  
  after_create :download
  
  EditableAttributes = [:caption, :source_url, :tags]
  
  def self.db_attributes
    EditableAttributes
  end
  
  private
  
  # Downloads from source & create new Content object with data
  
  def download
    return unless source_url
    
    filename = File.join(Dir::tmpdir, URI::parse(source_url).path.split('/').last)
    t = rio(filename) < rio(source_url) # Download to temp file

    if t.bytes > 0
      Photo.create(
      :parent_id => id,
      :owner => @member = backup_photo_album.backup_source.member,
      :content_type => Content.detect_mimetype(filename),
      :description => caption,
      :filename => File.basename(filename),
      :temp_path => File.new(filename)) do |p|    
        p.tag_with(tags.join(','), @member) if tags
        update_attribute(:content_id, p.id)
      end
    end
    rio(filename).delete
  end
    
end
