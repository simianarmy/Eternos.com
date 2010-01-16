# $Id$

# Table containing users' backup sites

class BackupSite < ActiveRecord::Base
  # Some site name constants for use in queries, views
  Facebook  = 'facebook'
  Twitter   = 'twitter'
  Gmail     = 'gmail'
  Blog      = 'blog'
  Picasa    = 'picasa'
  
  TypeMap  = {
    Gmail => 'email', 
    Blog  => 'rss'
  }
  validates_presence_of :name
  
  def self.names
    [Facebook, Twitter, Gmail, Blog, Picasa]
  end
  
  def type_name
    TypeMap.has_key?(name) ? TypeMap[name] : name
  end
end
