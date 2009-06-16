# $Id$

class BackupSource < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  has_many :backup_source_days
  
  validates_presence_of :auth_login
  validates_presence_of :auth_password
  validates_uniqueness_of :user_id, :scope => :backup_site_id
  
  named_scope :confirmed, :conditions => {:auth_confirmed => true}
  named_scope :needs_scan, :conditions => {:needs_initial_scan => true}
  
  def login_failed!(error) 
    update_attributes(:last_login_attempt_at => Time.now, :auth_error => error)
  end
  
  def logged_in!
    t = Time.now
    update_attributes(:last_login_attempt_at => t, :last_login_at => t, :auth_error => nil)
  end
end
