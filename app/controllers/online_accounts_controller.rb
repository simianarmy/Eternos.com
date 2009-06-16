class OnlineAccountsController < ApplicationController
  require 'twitter'
  before_filter :login_required
  require_role "Member"
  
  def create
    if params[:online_account] 
      online_account = OnlineAccount.find_or_create_by_username(params[:online_account][:username])
      case params[:name]
        when "facebook"
          #TODO:
        when "twitter"
          httpauth = Twitter::HTTPAuth.new(online_account.username, online_account.password)
          base = Twitter::Base.new(httpauth)

          if base.verify_credentials
            online_account.save!
            message = "Twitter account Activated"
          else
            message = "Twitter account is not valid"
          end
        when "flickr"
          #TODO:
      end
    end
    render_message(message)
  rescue
     render_message("Twitter account is not valid")
  end

  private

  def render_message(message)
    @rjs_message =  message
    respond_to do |format|
      format.js{
        render :update do |page|
         page.replace "rjs-message", :partial => "shared/rjs_message", :layout => false
         page.visual_effect :highlight, 'rjs-message'
        end
      }
    end
  end
end