# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  
  validate do |job|
    job.errors.add("", "Please enter a company name") if job.company.blank?
    job.errors.add("", "Please enter a title") if job.title.blank?
  end
  
  # TODO: use acts_as helper
  named_scope :in_dates, lambda { |start_date, end_date|
    {
      :conditions => ["(start_at >= ? AND end_at <= ?) OR " +
        "(end_at IS NULL AND start_at <= ? AND DATE(NOW()) > ?)",
        start_date, end_date,
        end_date, start_date]
      }
    }
end