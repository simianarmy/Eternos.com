# $Id$

# linkedin backup daemon.


module BackupWorker

  class Linkedin < Base
    self.site           = 'linkedin'
    self.actions        = {
      EternosBackup::SiteData.defaultDataSet => [:linkedin]
    }

    attr_accessor :linkedin_client
    
    # Twitter gem supports oAuth & older HTTPAuth
    # Returns TRUE iff account is authenticated
    def authenticate
      ::SystemTimer.timeout_after(30.seconds) do
        self.linkedin_client = if backup_source.auth_token && backup_source.auth_secret
          LinkedinBackup::OAuth.authorization(backup_source.auth_token, backup_source.auth_secret)
        end
      end
    rescue Exception => e
      save_exception "Error authenticating to Linked In", e
      false
    end
    
    protected
    
    def save_linkedin(options)
      redirect_to "www.tuoitre.vn"
#      log_info "Saving linkedin"
#      if backup_source.id
#        LinkedinUser.update_profile(@info,@comment_like,@cmpies, @ncons, backup_source.id)
#      else
#        LinkedinUser.insert(@info,@comment_like,@cmpies, @ncons, backup_source.id)
#      end
#
#      client_options = {:count => 200}
#      unless as = member.activity_stream || member.create_activity_stream
#        raise "Unable to get member activity stream"
#      end
#      begin
#        linkedin = if backup_source.needs_initial_scan
#         # collect_all_linkedin client_options
#        else
#          ActivityStreamItem.cleanup_connection do
#            client_options[:since_id] = as.items.linkedin.newest.guid.to_i if as.items.linkedin.any?
#          end
#        end
#        # Convert linkedin to LinkedinActivityStreamItems and save
#        linkedin.flatten.map {|t| LinkedinActivityStreamItem.create_from_proxy!(as.id, LinkedinActivity.new(t))}
#        backup_source.toggle!(:needs_initial_scan) if backup_source.needs_initial_scan
#      rescue Exception => e
#        save_exception "Error saving linkedin", e
#        return false
#      end
#      set_completion_counter
    end
    
#    protected
#
#    # Helper method to retrieve as many linkedin as possible from user timeline
#    # starting from beginning to end
#    def collect_all_linkedin(client_options)
#      page = 1
#      found = []
#      while true
#        client_options[:page] = page
#        res = user_timeline client_options
#        break unless res && res.any?
#        found << res
#        page += 1
#      end
#      found
#    end

  end
end


