# $Id$

class BackupSourceJob < ActiveRecord::Base
  belongs_to :backup_source
  belongs_to :backup_job
  
  validates_presence_of :backup_source
  validates_presence_of :backup_job
  
  serialize :errors
  serialize :messages
  xss_terminate :except => [ :errors, :messages ] # conflicts w/serialize
end
