# $Id$

# Table containing users' backup sites

class BackupSite < ActiveRecord::Base
  # Some site name constants for use in queries, views
  Facebook = 'facebook'
  
  validates_presence_of :name
end
