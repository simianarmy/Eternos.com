# $Id$

# Presenter class for Vault backup setup 

class Vault::BackupPresenter < SetupPresenter
   
  include BackupSourceActivation
  
  def load_backup_sources(user=@user)
    get_activations(user)
  end
  
  def load_facebook_user_info
    # Also get all facebook accounts' profile data to display in setup list
    if @facebook_confirmed
      begin
        Rails.logger.debug "FETCHING FACEBOOK ACCOUNT USERNAMES.."
        @facebook_accounts.each do |fb|
          Rails.logger.debug "fetching name for account #{fb.account_id}"

          fb_user = Mogli::User.find("me", Mogli::Client.new(fb.auth_token))
          Rails.logger.debug "Got user #{fb_user.inspect}"
          # Get name & pic
          if fb_user.name
            Rails.logger.debug "SUCCESS"
            @facebook_user = fb_user.name
            @facebook_pic = fb_user.square_image_url
            fb.update_attribute(:title, fb_user.name)
          else
            @facebook_confirmed = false
            @facebook_user = @facebook_pic = nil
          end
        end
      rescue Exception => e
        @facebook_confirmed = false
        @facebook_user = @facebook_pic = nil
        Rails.logger.error "Error in load_facebook_user_info: #{e.class} #{e.message}"
      end
    end
  end
  
end