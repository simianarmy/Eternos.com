# $Id$

# Proxy classes to normalize activity stream interface methods for passing to activerecord objects.
# Child classes used by ActiveRecord classes to create/update info in a consistent way

# See facebook_activity.rb for usage example

class ActivityStreamProxy < Hashie::Mash
  # TODO: For backwards compat - update client code
  def attachment_data
    attachment
  end
end