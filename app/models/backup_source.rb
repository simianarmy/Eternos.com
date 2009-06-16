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
  
end
