class BackupState < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  serialize :last_errors
  serialize :last_messages
  xss_terminate :except => [ :last_errors, :last_messages ] # conflicts w/serialize
  
  # Save latest backup status with passed info hash data
  
  def finished!(info)
    self.in_progress = false
    self.last_backup_finished_at = Time.now
    self.last_backup_job_id = info[:job_id]
    
    if info[:errors].empty?
      self.last_successful_backup_at = Time.now
      self.last_messages = info[:messages] if info[:messages]
      self.last_errors.clear
    else
      self.last_failed_backup_at = Time.now
      self.last_errors = info[:errors]
    end
    save!
  end
  
  # Tries to estimated time left in current backup job
  def time_remaining
    member.backup_jobs.recent.time_remaining rescue 0
  end
        
end
