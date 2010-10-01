# $Id$

class EmailBlacklist < ActiveRecord::Base
  validates_presence_of :email, :message => 'email should not be empty'
  validates_uniqueness_of :email, :message => 'such email is already in unsubscription list'
end