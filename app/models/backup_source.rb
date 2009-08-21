# $Id$

class BackupSource < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :backup_source_days
  has_many :backup_photo_albums
  has_many :backup_source_jobs
  
  #after_create :cb_after_create_init_backup
  
  named_scope :by_site, lambda {|name|
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => name}
    }
  }
  named_scope :confirmed, :conditions => {:auth_confirmed => true}
  named_scope :needs_scan, :conditions => {:needs_initial_scan => true}
  named_scope :photo_album, lambda {|id| 
    { :joins => :backup_photo_albums, :conditions => {'backup_photo_albums.source_album_id' => id} }
  }
  
  # Uses searchlogic association named_scope to find all photos
  # def photos
  #     backup_photo_albums.backup_photos_id_not_null.map(&:backup_photos)
  #   end
  
  def login_failed!(error) 
    update_attributes(:last_login_attempt_at => Time.now, :auth_error => error)
  end
  
  def logged_in!
    t = Time.now
    update_attributes(:last_login_attempt_at => t, :last_login_at => t, :auth_error => nil)
  end
  
  def auth_required?
    true
  end
  
  def confirmed?
    auth_confirmed
  end
  
  def confirmed!
    update_attribute(:auth_confirmed, true)
    #  Initiate backup on auth confirmation
    reload.backup  
  end
  
  # add this backup source to backup queue
  def backup
    BackupJobPublisher.add_source(self)
  end
  
  def photo_album(id)
    backup_photo_albums.find_by_source_album_id(id)
  end
  
  def photos
    backup_photo_albums.map(&:backup_photos).flatten
  end
  
  def photos_between_dates(s, e)
    BackupPhoto.find backup_photo_albums.photos_between_dates(s, e).map(&:id)
  end
  
  private
  
end
