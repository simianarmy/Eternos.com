# $Id$

class BackupSourceDay < ActiveRecord::Base
  belongs_to :backup_source
  
  validates_presence_of :backup_day
  
  named_scope :complete, :conditions => { :status_id => BackupStatus::Success }, 
    :order => 'backup_day'
  named_scope :failed, :conditions => 
    ['status_id != ? AND in_progress = 0 AND skip != 1', BackupStatus::Success],
    :order => 'backup_day'
end
