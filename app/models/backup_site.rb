# $Id$

# Table containing users' backup sites

class BackupSite < ActiveRecord::Base
  validates_presence_of :name
end
