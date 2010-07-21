# $Id$

class BackupJobError < ActiveRecord::Base
  # Takes 1 or more errors & increments its count
  def self.increment_errors_count(*errs)
    errs.each do |err|
      if e = find_or_create_by_error_text(err)
        e.increment(:count, 1)
        e.save
      end
    end
  end
      
end