# $Id$

class FacebookContent < ActiveRecord::Base
  belongs_to :profile
  
  acts_as_audited
  
  serialize :friends
  serialize :groups
  xss_terminate :except => [ :friends, :groups ]
  
  # Helper for update with acts_as_audited helper specifying the user making changes.
  def save_audited(attribute, user, val)
    self.class.audit_as(user) { update_attribute(attribute, val) }
  end
end
