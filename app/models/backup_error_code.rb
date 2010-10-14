# Contains backup error text strings
class BackupErrorCode < ActiveRecord::Base
  validates_presence_of :code, :description, :fix_hint

end