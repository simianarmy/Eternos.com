# $Id$

# Table for backup process info

class BackupJob < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  # Will save backup job status on completion.  Will update member's 
  # backup status if associated with one
  
  def finish!(info)
    update_attributes(
      :finished_at => Time.now,
      :size => info[:total_bytes] ? info[:total_bytes].to_i + 0 : 0,
      :status => info[:status],
      :cancelled => info[:cancel])
      
    member.backup_finished!(info) if member
  end
end
