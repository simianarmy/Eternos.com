# $Id$
class Circle < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Member', :foreign_key => 'user_id'
  has_many :relationships
  has_many :members, :through => :relationships, :source => :guest
  
  validates_presence_of :name, :message => "Please Select a Relationship"
  
  named_scope :globals, :conditions => {:user_id => 0}, :order => :name
end
