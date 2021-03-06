# $Id$

class GuestRelationship < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :guest, :foreign_key => 'guest_id'
  belongs_to :circle
  
  validates_existence_of :member, :message => "Member not found"
  validates_existence_of :guest, :message => "Guest not found"
  validates_existence_of :circle, :message => "Circle not found"
end