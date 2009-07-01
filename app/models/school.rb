# $Id$

class School < ActiveRecord::Base
  belongs_to :profile
  
  validate do |school|
    school.errors.add("", "Please enter a school name") if school.name.blank?
  end
end