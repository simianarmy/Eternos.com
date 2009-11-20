# $Id$
class Relationship < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :guest, :foreign_key => 'guest_id'
  belongs_to :circle
  
  validates_existence_of :member, :message => "Member not found"
#  validates_existence_of :guest, :message => "Guest not found"
  #validates_existence_of :circle, :message => "Circle not found"
  validates_presence_of :name, :message => "Please enter a full name"
  validates_presence_of :description, :message => "Please enter a description of the relationship"  
  # -marc
  # A Relationship name what Circle class is used for.
  # Use Circle table to populate relationship options in forms.
  
  include TimelineEvents

end
