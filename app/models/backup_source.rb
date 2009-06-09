# $Id$

class BackupSource < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :backup_site
  
  validates_presence_of :auth_login
  validates_presence_of :auth_password
  
  named_scope :confirmed, :conditions => {:auth_confirmed => true}
end
