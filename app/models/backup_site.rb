# $Id$

# Table containing users' backup sites

class BackupSite < ActiveRecord::Base
  has_and_belongs_to_many :member, :foreign_key => 'user_id'
  
  validates_presence_of :name
end
