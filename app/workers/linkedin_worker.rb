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
     puts "linkedin ........................................\n"
       self.linkedin_client = if backup_source.auth_token && backup_source.auth_secret
       consumer = LinkedinBackup::OAuth.authorization(backup_source.auth_token, backup_source.auth_secret)
		
	@comment_like = consumer.get_network_update('STAT')
        @info = consumer.get_profile('all')
        @cmpies = consumer.get_network_update('CMPY')
	@ncons = nil #consumer.get_network_update('NCON')
        end

      
        
	if record = LinkedinUser.find_all_by_backup_source_id(backup_source.id).first
 	     record.update_profile(@info, @comment_like, @cmpies, @ncons)
	else
	    LinkedinUser.insert(@info, @comment_like, @cmpies, @ncons, backup_source.id)
	end
    end

  end
end


