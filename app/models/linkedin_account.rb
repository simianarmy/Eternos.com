# $Id$

# BackupSource STI child

class LinkedinAccount < BackupSource
  has_one :linkedin_user, :foreign_key => 'backup_source_id'
end