# $Id$

class FacebookContent < ActiveRecord::Base
  belongs_to :profile
  
  serialize [:friends, :groups]
  xss_terminate :except => [ :friends, :groups ]
  
end
