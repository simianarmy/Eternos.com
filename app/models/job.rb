# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  
  validate do |job|
    job.errors.add("", "Please enter a company name") if job.company.blank?
    job.errors.add("", "Please enter a title") if job.title.blank?
  end
  
end