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
      self.last_errors.clear if self.last_errors
    else
      self.last_failed_backup_at = Time.now
      self.last_errors = info[:errors]
    end
    # Do one time calculation of backup data items available & save
    unless self.items_saved
      @first_time_backup_data_available = self.items_saved = has_data?
    else
      @first_time_backup_data_available = false
    end
    save!
  end
  
  # Tries to estimated time left in current backup job
  def time_remaining
    member.last_backup_job.time_remaining rescue 0
  end
  
  def first_time_data_available?
    !!@first_time_backup_data_available
  end
  
  # Tries to determine if a user has disabled backups.  Takes a # of days to use as 
  # threshold for inactivity
  def inactive?(day_threshold)
    # WARNING:
    # These must not be re-ordered without knowing why - we are using boolean cutoffs that 
    # could result in nil errors otherwise!
    disabled || 
    last_backup_finished_at.nil? || 
    ((Time.now - last_backup_finished_at) > day_threshold) ||
    last_successful_backup_at.nil? ||
    ((Time.now - last_successful_backup_at) > day_threshold)
  end
  
  protected
  
  # true if last backup job has any saved backup records, or activity stream not empty
  def has_data?
    member.activity_stream.items.any? ||
      BackupJob.find(self.last_backup_job_id).backup_source_jobs.map(&:backup_source).any? do |bs|
        bs.num_items > 0
      end
  rescue 
    false
  end
end
