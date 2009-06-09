# $Id$
module ContentAuthorizationHelper
  def options_for_authorization_select(object)
    object.authorization_select_options
  end
end
