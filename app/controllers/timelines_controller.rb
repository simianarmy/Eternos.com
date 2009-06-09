# $Id$
class TimelinesController < ApplicationController
  before_filter :login_required
  require_role 'Guest'
  before_filter :find_host
  layout 'guest', :except => :index
  
  def index
    permit "guest of :host" do
      @stories = @host.authorized_stories(current_user)
    end
  end
  
  def find_host
    @host = current_user.get_host
  end
end
