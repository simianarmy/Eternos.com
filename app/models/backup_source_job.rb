# $Id$

class BackupSourceJob < ActiveRecord::Base
  belongs_to :backup_source
  belongs_to :backup_job
  
  validates_presence_of :backup_source_id
  validates_presence_of :backup_job_id
  
  serialize :error_messages
  serialize :messages
  xss_terminate :except => [ :error_messages, :messages ] # conflicts w/serialize
end
