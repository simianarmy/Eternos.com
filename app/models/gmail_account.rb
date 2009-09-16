# $Id$

# BackupSource STI child

class GmailAccount < BackupSource
  has_many :backup_emails, :foreign_key => 'backup_source_id'
  
  validates_presence_of :auth_login
  validates_presence_of :auth_password, :message => "Password required"
  validates_uniqueness_of :auth_login, :message => "Email already saved", :scope => :user_id
  
  alias_attribute :email, :auth_login
  
  def num_items
    backup_emails.size
  end
end