# $Id$
class JavascriptsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  layout nil
end
