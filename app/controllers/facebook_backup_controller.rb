# $Id$

require 'facebook_desktop'

class FacebookBackupController < ApplicationController
  before_filter :login_required
  require_role "Member"
   
  def new
    @login_url = FacebookDesktopApp::Session.create.login_url
  end
  
  def authorized
  end
  
  def removed
  end
  
  def canvas
  end
end
