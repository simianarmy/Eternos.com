# $Id$

class EmailBlacklist < ActiveRecord::Base
  validates_presence_of :email, :message => 'Please enter an email address'
end