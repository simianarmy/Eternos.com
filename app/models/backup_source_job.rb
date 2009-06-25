# $Id$

class BackupSourceJob < ActiveRecord::Base
  belongs_to :backup_source
  belongs_to :backup_job
  
  validates_presence_of :backup_source_id
  validates_presence_of :backup_job_id
  
  serialize :error_messages
  serialize :messages
  xss_terminate :except => [ :error_messages, :messages ] # conflicts w/serialize
  
  def successful?
    status && (status == BackupStatus::Success)
  end
  
  def reset_progress
    update_attribute(:percent_complete, 0)
  end
end
