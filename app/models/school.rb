# $Id$

class School < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a school name"
end