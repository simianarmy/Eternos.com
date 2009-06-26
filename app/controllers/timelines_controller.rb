# $Id$
class TimelinesController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']
  
  def guest_index
    find_host
    permit "guest of :host" do
      @stories = @host.authorized_stories(current_user)
    end
    layout 'guest'
  end
  
  def index
    # Right now just raw info for debug output
    @profile = current_user.profile
    @facebook_profile = @profile.facebook_data
    @facebook_friends = @profile.facebook_content.friends
    @facebook_groups = @profile.facebook_content.groups
    if bs = current_user.backup_sources
      bs.each do |source|
        (@photo_albums ||= []) << source.backup_photo_albums
      end
    end
    @activity_streams = current_user.activity_streams
  end
  
  def find_host
    @host = current_user.get_host
  end
  
end
