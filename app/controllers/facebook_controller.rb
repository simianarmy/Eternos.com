# $Id$

class FacebookController < ApplicationController
  before_filter :ensure_authenticated_to_facebook
  layout nil
  
  def index
  end
end
