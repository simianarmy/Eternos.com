# $Id$
#require 'story' # Needed for has_many_polymorphs load error on :stories

class Category < ActiveRecord::Base
 # has_many_polymorphs :categorizables, :from => [:stories, :messages], 
#    :through => :categorizations
  
  validates_presence_of :name, :message => "Please Enter A Category Name"

  scope_out :globals, :conditions => ['global = 1'], :order => :name
  
  def global?
    global
  end
end
