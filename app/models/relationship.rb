# $Id$
class Relationship < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a full name"
  validates_presence_of :description, :message => "Please enter a description of the relationship"  
  
  acts_as_archivable :on => :start_at
  
  include TimelineEvents

end
