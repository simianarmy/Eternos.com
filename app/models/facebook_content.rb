# $Id$

class FacebookContent < ActiveRecord::Base
  belongs_to :profile
  
  serialize :friends
  serialize :groups
  xss_terminate :except => [ :friends, :groups ]
  
  # TODO: Version (vestal_versions?) to keep track of changes by date
end
