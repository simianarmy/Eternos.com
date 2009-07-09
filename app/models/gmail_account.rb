# $Id$

# BackupSource STI child

class GmailAccount < BackupSource
  validates_presence_of :auth_login
  validates_presence_of :auth_password
  validates_uniqueness_of :auth_login, :message => "Email already saved"
  
  alias_attribute :email, :auth_login
end