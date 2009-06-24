# $Id$

require 'twitter'

class BackupSourcesController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def create
    if params[:site_name]
      backup_site = BackupSite.find_by_name(params[:site_name])
      case params[:site_name]
        when "facebook"
          #TODO:
        when "twitter"
          httpauth = Twitter::HTTPAuth.new(params[:backup_source][:auth_login], params[:backup_source][:auth_password])
          base = Twitter::Base.new(httpauth)
          if base.verify_credentials

            backup_source = BackupSource.find_by_user_id(current_user.id, :conditions => ["backup_site_id = 1 and auth_login = ? ", params[:backup_source][:auth_login]])
            if backup_source.nil?
              backup_source = BackupSource.new(params[:backup_source].merge({:user_id => current_user.id, :backup_site_id => backup_site.id}))
            else
              backup_source.attributes = params[:backup_source]
            end
            if backup_source.save
              message = "activated"
            end
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
         if message != "activated"
           page.replace "rjs-message", :partial => "shared/rjs_message", :layout => false
           page["twitter-link"].removeClassName('twitter-active')
           page["twitter-link"].addClassName('twitter-btn')
           page.visual_effect :highlight, 'rjs-message'
         else
           @rjs_message =  ""
           page.replace "rjs-message", :partial => "shared/rjs_message", :layout => false
           page["twitter-link"].removeClassName('twitter-btn')
           page["twitter-link"].addClassName('twitter-active')
         end

        end
      }
    end
  end
end