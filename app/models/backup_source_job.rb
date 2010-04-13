# $Id$

class BackupSourceJob < ActiveRecord::Base
  belongs_to :backup_source
  belongs_to :backup_job
  
  validates_presence_of :backup_source_id
  validates_presence_of :backup_job_id
  
  serialize :error_messages
  serialize :messages
  xss_terminate :except => [ :error_messages, :messages ] # conflicts w/serialize
  
  acts_as_archivable :on => :created_at
  
  def successful?
    status && (status == BackupStatus::Success)
  end
  
  def has_errors?
    !!error_messages.try(:any?)
  end
  
  def reset_progress
    update_attribute(:percent_complete, 0)
  end
  
  def finished!
    t = Time.now
    update_attribute(:finished_at, t)
    backup_source.update_attribute(:last_backup_at, t)
    backup_source.backup_complete!
  end
  
  def finished?
    !!finished_at
  end
  
  def expired?(ds=0)
    !finished? && ((Time.now - created_at) > time_to_expire(ds))
  end
  
  def time_to_expire(ds=0)
    EternosBackup::DataSchedules.min_backup_interval(ds)
  end
  
  def time_remaining(ds=0)
    return 0 if finished?
    
    remaining = 0
    if percent_complete > 0 && percent_complete < 100
      elapsed = [(time_spent = Time.now - created_at), 1].max
      percent_per_second = percent_complete / elapsed
      remaining = (100 - percent_complete) * percent_per_second
    else 
      remaining = 10.minutes # some bs number
    end
    remaining
  end
  
end
