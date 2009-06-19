# $Id$
class Decoration < ActiveRecord::Base
  belongs_to  :decoratable, :polymorphic => true
  belongs_to :content
  acts_as_list :scope => :decoratable
  
  named_scope :element, :conditions => {:decoratable_type => 'Element'}
  named_scope :message, :conditions => {:decoratable_type => 'Message'}
end
