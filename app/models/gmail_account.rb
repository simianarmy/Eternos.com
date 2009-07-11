# $Id$

# BackupSource STI child

class GmailAccount < BackupSource
  has_many :backup_emails, :foreign_key => 'backup_source_id'
  
  validates_presence_of :auth_login
  validates_presence_of :auth_password
  validates_uniqueness_of :auth_login, :message => "Email already saved"
  
  alias_attribute :email, :auth_login
end