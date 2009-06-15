# $Id$
class MemberHomeController < ApplicationController
  ssl_allowed :index
  before_filter :login_required
  require_role "Member"
  
  def index
    @name = current_user.name
  end
  
  def online_account
    case online_account
      when "facebook"
        #TODO:
      when "twitter"
        httpauth = Twitter::HTTPAuth.new(config['email'], config['password'])
        base = Twitter::Base.new(httpauth)
        
        if base.verify_credentials
          OnlineAccount.create({:name => site, :user_id => current_user.id, :username => params[:username], :password => params[:password]})
        end
      when "flickr"
        #TODO:
    end
    render :nothing => true
  end
end
