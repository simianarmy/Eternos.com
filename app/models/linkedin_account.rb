# $Id$

# BackupSource STI child

class LinkedinAccount < BackupSource
  has_one :linkedin_user
end