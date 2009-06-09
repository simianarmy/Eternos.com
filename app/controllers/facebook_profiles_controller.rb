# $Id$

class FacebookProfilesController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_session
  
  def show
    @response = {}
    if facebook_session && (fb_user = facebook_session.user)
      begin
        if fb_user.populate(*Facebooker::User::FIELDS)
          profile = {}
          Facebooker::User::FIELDS.each {|f| profile[f] = fb_user.send(f)}
          @response = {:status => 200, :profile => profile}
        else
          @response = {:status => 500, :error => 'Populate method failed'}
        end
      rescue Exception => e
        @response = {:status => 500, :error => 'Exception fetching profile: ' + e.to_s}
      end
    else
      @response = {:status => 500, :error => 'No facebook session user'}
    end
    
    respond_to do |format|
      # For debugging
      format.html { render :text => @response.to_json }
      # For ajax clients
      format.js { render :json => @response.to_json }
    end
  end
end
