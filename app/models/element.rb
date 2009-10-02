# $Id$
class Element < ActiveRecord::Base
  belongs_to :story
  
  acts_as_archivable
  acts_as_decoratable
  acts_as_commentable
  acts_as_restricted :owner_method => :owner
  acts_as_time_period
  acts_as_list :scope => :story
  #acts_as_taggable_custom :owner_method => Proc.new {|e| e.story.member}
  acts_as_taggable_on :tags
  acts_as_time_locked
  
  attr_accessor :with_new_decoration
  
  validates_existence_of :story
  validates_presence_of :title, :message => "Please Enter a Title", :unless => :with_new_decoration
  validates_presence_of :message, :message => "Please Enter a Message", :unless => :with_new_decoration
  validates_as_time_period
  
  xss_terminate :except => [:message]
  
  def owner
    story.member
  end
  
end
