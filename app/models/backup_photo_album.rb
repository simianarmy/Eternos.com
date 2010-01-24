# $Id$

class BackupPhotoAlbum < ActiveRecord::Base
  belongs_to :backup_source
  has_many :backup_photos, :dependent => :destroy do
    def import(photo)
      create({:source_photo_id => photo.id.to_s}.merge(photo.to_h))
    end
  end
  has_many :content_photos, :through => :backup_photos, :source => :photo
  has_one :owner, :through => :backup_source, :source => :member
  
  validates_presence_of :backup_source_id
  validates_uniqueness_of :source_album_id, :scope => :backup_source_id
  
  acts_as_restricted :owner_method => :owner
  acts_as_archivable :on => :created_at
  acts_as_time_locked
  acts_as_taggable
  acts_as_commentable
  
  alias_method :photos, :backup_photos
  
  serialize_with_options(:gallery) do
    methods :cover_photo_url
    except :id, :backup_source_id, :source_album_id, :cover_id
    # Because serialize_with_options only supports 1 level of nesting, we have 
    # to specify the attributes to exclude manually in the include hash - booo
    includes :content_photos => { 
        :methods => [:url, :thumbnail],
        :except => [:id, :size, :type, :filename, :thumbnail, :bitrate, :created_at, 
          :updated_at, :user_id, :content_type, :duration, :version, :processing_error_message,
          :fps, :state, :is_recording, :s3_key] 
      }
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
  named_scope :by_user, lambda { |id| 
      {
        :joins => :backup_source,
        :conditions => ['backup_sources.user_id = ?', id]
      }
    }
#  scope_procedure :by_user, lambda { |user_id| 
#    backup_source_user_id_eq(user_id)
#  }
  named_scope :include_content_photos, :include => :content_photos
  
  # thinking_sphinx
  define_index do
    # fields
    indexes :name
    indexes description
    indexes location
    
    # attributes
    has backup_source_id, created_at, updated_at
    
    where "deleted_at IS NULL"
  end
  
  @@editableAttributes = [:cover_id, :size, :name, :description, :location, :modified]
  @@facebookFriendsAlbumName = 'Photos From Facebook Friends'
  @@facebookFriendsAlbumID = '11111'
  cattr_reader :editableAttributes, :facebookFriendsAlbumName, :facebookFriendsAlbumID
  
  def self.import(source, album)
    self.create!(
      {:backup_source => source, :source_album_id => album.id}.merge(album.to_h)
    )
  end
  
  def self.db_attributes
    editableAttributes
  end

  # Helper to find or create an album for all 3rd party facebook images
  def self.find_or_create_facebook_friends_album(backup_source_id)
    BackupPhotoAlbum.find_or_initialize_by_backup_source_id_and_source_album_id(backup_source_id,
      facebookFriendsAlbumID) do |album|
      album.name = facebookFriendsAlbumName
      album.save
    end
  end
  
  # Returns content Photo object for the album cover
  def cover_photo
    # Try to avoid using invalid photos if there are multiple backup photos with the 
    # same source photo id
    begin
      BackupPhoto.source_photo_id_eq(cover_id).include_content.map(&:photo).compact.first || 
      content_photos.first
    rescue 
      nil
    end
  end
  
  def cover_photo_url
    @cover.url if @cover ||= cover_photo
  end
  
  def num_items
    backup_photos.size
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
      p.destroy unless new_photo_ids.include?(p.source_photo_id)
    end
    
    # Add all new photos
    new_photos.each do |p|
      backup_photos.import(p) unless existing_photo_ids.include?(p.id)
    end
  end

  # Earliest photo's date or album create date or some reasonable default
  def start_date
    if backup_photos.any?
      backup_photos.oldest.added_at
    elsif created_at
      created_at
    elsif modified
      Time.at(modified.to_i)
    else
      Date.today
    end
  end
  
  def to_s
    "#{source_album_id} : #{name} : #{description}"
  end
end
