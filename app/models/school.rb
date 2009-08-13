# $Id$

class School < ActiveRecord::Base
  belongs_to :profile
  
  acts_as_archivable :on => :start_at
  
  validate do |school|
    school.errors.add("", "Please enter a school name") if school.name.blank?
  end
  
  # TODO: use acts_as helper
  named_scope :in_dates, lambda { |start_date, end_date|
    {
      :conditions => ["(start_at >= ? AND end_at <= ?) OR " +
        "((end_at IS NULL) AND (start_at <= ?) AND (DATE(NOW()) > ?))",
        start_date, end_date,
        end_date, start_date]
      }
    }
end