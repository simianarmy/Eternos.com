# $Id$

# Table of completed backup jobs with status

class BackupJobArchive < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
end
