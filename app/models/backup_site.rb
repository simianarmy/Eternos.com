# $Id$

# Table containing users' backup sites

class BackupSite < ActiveRecord::Base
  # Some site name constants for use in queries, views
  Facebook  = 'facebook'
  Twitter   = 'twitter'
  Gmail     = 'gmail'
  Flickr    = 'flickr'
  Blog      = 'blog'
  
  validates_presence_of :name
end
