# $Id$

# Table for backup process info

class BackupJob < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  has_many :backup_source_jobs
  
  serialize :error_messages
  xss_terminate :except => [:error_messages]
  acts_as_archivable :on => :created_at
  
  # Will save backup job status on completion.  Will update member's 
  # backup status if associated with one
  
  def finish!(info)
    update_attributes(
      :finished_at => Time.now,
      :size => info[:total_bytes] ? info[:total_bytes].to_i + 0 : 0,
      :status => info[:status],
      :cancelled => info[:cancel],
      :error_messages => info[:errors])
      
    member.backup_finished!(info) if member
  end
  
  # Return earliest estimated job completion time
  def shortest_time_remaining
    return 0 if finished_at
    backup_source_jobs.map(&:time_remaining).reject! {|t| t == 0}.min rescue 0
  end
  
  # Tries to estimated time left in current backup job (in seconds)
  def time_remaining
    return 0 if finished_at
    backup_source_jobs.map(&:time_remaining).sum
  end
  
  def successful?
    status && (status == "ok")
  end
  
  def has_errors?
    !!error_messages.try(:any?)
  end
end
