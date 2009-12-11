# $Id$
class Relationship < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  validates_existence_of :member, :message => "Member not found"
  validates_presence_of :name, :message => "Please enter a full name"
  validates_presence_of :description, :message => "Please enter a description of the relationship"  
  
  include TimelineEvents

end
