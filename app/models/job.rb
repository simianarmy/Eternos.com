# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  
  acts_as_archivable :on => :start_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  validates_presence_of :company, :message => "Please enter a company name"
  validates_presence_of :title, :message => "Please enter a job title"
  
  include TimelineEvents
  
  # TODO: use acts_as helper
  named_scope :in_dates, lambda { |start_date, end_date|
    {
      :conditions => ["(start_at >= ? AND end_at <= ?) OR " +
        "(end_at IS NULL AND start_at <= ? AND DATE(NOW()) > ?)",
        start_date, end_date,
        end_date, start_date]
      }
    }
  
  # thinking_sphinx
  define_index do
    indexes company
    indexes title
    indexes description
    indexes notes
    
    has profile_id, start_at, end_at
  end
end