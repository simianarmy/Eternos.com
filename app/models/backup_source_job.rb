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
  
  def time_remaining
    return 0 if finished_at
    
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
