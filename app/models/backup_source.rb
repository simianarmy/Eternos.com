# $Id$
require 'attr_encrypted'

class BackupSource < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :backup_source_days
  has_many :backup_photo_albums
  has_many :backup_source_jobs
  
  @@max_consecutive_failed_backups  = 25 # Should be about 1 day's worth
  cattr_reader :max_consecutive_failed_backups
  
  #after_create :cb_after_create_init_backup
  # The new hotness
  # TODO: migrate unencrypted values to these columns, then rename columns & drop these
  attr_encrypted :auth_login2, :auth_password2, :key => 'peek a choo moo', :prefix => '', :suffix => '_enc'
  
  named_scope :by_site, lambda {|name|
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => name}
    }
  }
  named_scope :twitter, lambda {
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => BackupSite::Twitter}
    }
  }
  named_scope :facebook, lambda {
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => BackupSite::Facebook}
    }
  }
  named_scope :blog, lambda {
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => BackupSite::Blog}
    }
  }
  named_scope :gmail, lambda {
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => BackupSite::Gmail}
    }
  } 
  named_scope :picasa, lambda {
    {
      :joins => :backup_site,
      :conditions => {'backup_sites.name' => BackupSite::Picasa}
    }
  }
  named_scope :active, :conditions => {
    :auth_confirmed => true, :backup_state => [:pending, :backed_up], :deleted_at => nil
  }
  named_scope :needs_scan, :conditions => {:needs_initial_scan => true}
  named_scope :photo_album, lambda {|id| 
    { :joins => :backup_photo_albums, :conditions => {'backup_photo_albums.source_album_id' => id} }
  }
  
  acts_as_state_machine :initial => :pending, :column => 'backup_state'
  state :pending
  state :backed_up
  state :disabled
  
  event :backup_complete do
    transitions :from => [:pending, :disabled], :to => :backed_up
  end
  
  event :backup_error_max_reached do
    transitions :from => [:pending, :backed_up], :to => :disabled
  end
  
  # Returns most recent BackupSourceJob
  def latest_backup
    backup_source_jobs.newest
  end
  
  # Returns backup data type sets associated with this site
  def backup_data_sets
    EternosBackup::SiteData.site_data_sets(backup_site)
  end
  
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
    !!auth_confirmed
  end
  
  def confirmed!
    unless confirmed?
      update_attribute(:auth_confirmed, true)
      #  Initiate backup on auth confirmation
      reload.backup  
    end
  end
  
  def active?
    !self.disabled? && !self.deleted_at
  end
  
  # add this backup source to backup queue
  def backup
    EternosBackup::BackupJobPublisher.add_source(self)
  end
  
  def next_backup_at
    EternosBackup::BackupScheduler.next_source_backup_at(self)
  end
  
  # Counts how many times most recent backup jobs have failed in a row, 
  # Stopping after 1st successful backup
  def consecutive_failed_backup_jobs
    count = 0
    backup_source_jobs.descend_by_created_at.each do |job|
      break if job.successful?
      count += 1
    end
    count
  end
  
  def backup_broken?
    consecutive_failed_backup_jobs >= self.max_consecutive_failed_backups
  end
  
  # These photo methods should not be here
  def photo_album(id)
    backup_photo_albums.find_by_source_album_id(id)
  end
  
  def photos
    backup_photo_albums.map(&:backup_photos).flatten
  end
  
  def photos_between_dates(s, e)
    BackupPhoto.find backup_photo_albums.photos_between_dates(s, e).map(&:id)
  end
  
  def num_items
    backup_photo_albums.size
  end
    
  # Descriptive title for source
  def description
    returning String.new do |d|
      d << backup_site.name.capitalize 
      if title && !title.blank?
        d << " - " << title
      elsif respond_to?(:name) && !name.blank?
        d << " - " << name 
      end
    end
  end
  
  private
  
end
