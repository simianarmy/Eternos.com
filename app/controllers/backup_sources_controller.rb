class BackupSourcesController < ApplicationController
  require 'twitter'
  before_filter :login_required
  require_role "Member"
  
  def create
    if params[:site_name] 
      online_account = BackupSource.find_or_create_by_auth_login(params[:backup_source][:auth_login])
      case params[:site_name]
        when "facebook"
          #TODO:
        when "twitter"
          httpauth = Twitter::HTTPAuth.new(online_account.auth_login, online_account.auth_password)
          base = Twitter::Base.new(httpauth)
          if base.verify_credentials
            BackupSource.create(params[:backup_source].merge(:user_id => current_user.id))
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