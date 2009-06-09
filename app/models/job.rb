# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :company, :message => 'Please enter a company name'
  validates_presence_of :title, :message => 'Please enter a title (position)'
end