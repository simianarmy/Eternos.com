# $Id$
class Relationship < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a full name"
  validates_presence_of :description, :message => "Please enter a description of the relationship"  
  
  acts_as_archivable :on => :start_at
  
  include TimelineEvents

  # thinking_sphinx
  define_index do
    indexes :name
    indexes description
    indexes notes
    
    has profile_id, start_at, end_at
  end
end
