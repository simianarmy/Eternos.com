# $Id$
class Decoration < ActiveRecord::Base
  belongs_to  :decoratable, :polymorphic => true
  belongs_to :content
  acts_as_list :scope => :decoratable
  
  scope_out :element, :conditions => ['decoratable_type = ?', 'Element']
  scope_out :message, :conditions => ['decoratable_type = ?', 'Message']
end
