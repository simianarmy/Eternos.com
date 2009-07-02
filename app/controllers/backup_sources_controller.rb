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

  def add_feed_url
    begin
      @feed_url = FeedUrl.new(params[:feed_url].merge(:profile_id => current_user.profile.id))
      if @feed_url.save!
        find_feed_rss_url
        render :update do |page|
          page[:feed_url_url].value = ""
          page.replace_html "url-list", :partial => 'shared/url_list', :locals => {:feed_urls => @feed_urls}
        end
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-rss", :inline => "<%= error_messages_for 'feed_url' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                            
        end
      end
    end
  end
  
  def destroy_feed_url
    @feed = FeedUrl.find(params[:id])
    @feed.destroy
    
    find_feed_rss_url
    render :update do |page|
      page.replace_html "url-list", :partial => 'shared/url_list', :locals => {:feed_urls => @feed_urls}
    end
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
  
  def find_feed_rss_url
    @feed_urls = current_user.profile.feed_urls
  end
  
end