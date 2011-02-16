# Support files for backup daemons
require File.join(File.dirname(__FILE__), 'facebook_user_profile')
require File.join(File.dirname(__FILE__), 'facebook_proxy_objects')
require 'facebooker' # Shouln't be necesary...

# Add missing attributes to Facebooker models
module Facebooker
  class Album
    populating_attr_accessor :object_id, :edit_link, :can_upload, :type, :modified_major
  end
  class Photo
    populating_attr_accessor :object_id
  end
  class Comment
    populating_attr_accessor :username
  end
  class Group
    populating_attr_accessor :icon, :pic_square, :version, :email
  end
  class MessageThread
    populating_attr_accessor :folder_id, :viewer_id
    
    class Message::Attachment
      populating_attr_accessor :media, :tagged_ids, :properties, :fb_object_id, :fb_object_type
    end
  end
end

# FacebookBackup module
#
# Wrapper for Facebook backup applications

module FacebookBackup
  # Vault module
  module Vault
    @@config_path = File.join(RAILS_ROOT, 'config', 'facebooker_vault.yml')
    mattr_accessor :config_path
  end
  
  # General backup module
  @@config_path = File.join(RAILS_ROOT, 'config', 'facebooker_desktop.yml')
  
  @@all_permissions = %W( 
    publish_stream 
    offline_access 
    read_stream 
    read_mailbox
    user_about_me
    user_activities
    user_birthday
    user_education_history
    user_events
    user_groups
    user_hometown
    user_interests
    user_likes
    user_location
    user_notes
    user_online_presence
    user_photo_video_tags
    user_photos
    user_relationships
    user_religion_politics
    user_status
    user_videos
    user_website
    user_work_history
    read_friendlists
  )
  @@backup_permissions = %W( 
    publish_stream 
    offline_access 
    read_stream
    user_photos
    )
  mattr_accessor :config_path, :all_permissions, :backup_permissions
    
  # Wrapper around Facebooker's load_configuration method - adds exception handling, 
  # default config file name
  class << self
    def load_config(path=nil)
      path = config_path if path.nil? || path.blank?

      raise "Unable to load #{path}" unless File.exist? path
      Facebooker.load_configuration(path)
    end
  end
  
  class Session < Facebooker::Session::Desktop
    attr_reader :config, :errors, :app_id, :access_token
    
    def self.create(config=nil)
      conf = FacebookBackup.load_config(config)
      
      me = super(conf['api_key'], conf['secret_key'])
      # Add additional config values
      me.instance_variable_set("@app_id", conf['app_id'])
      me.instance_variable_set("@access_token", conf['access_token'])
      me
    end
    
    # IMPORTANT - Needed to override post to always use the session_key!
    # If this is not set then we will get InvalidSignature errors for every desktop request
    def post(method, params = {}, use_session=false)
      if method == 'facebook.profile.getFBML' || method == 'facebook.profile.setFBML'
        raise NonSessionUser.new("User #{@uid} is not the logged in user.") unless @uid == params[:uid]
      end
      super(method, params, true)
    end
    
    def connect(session, uid, timeout, secret)
      secure_with!(session, uid, timeout, secret)
    end

    # Returns login url + required permissions code
    def login_url_with_perms(options={})
      # If oauth-style authentication
      if self.access_token
        "https://www.facebook.com/dialog/oauth?client_id=#{app_id}&redirect_uri=#{CGI::escape(options[:next])}&scope=#{FacebookBackup.all_permissions.join(',')}"
      else # old-school authentication
        "http://www.facebook.com/login.php?api_key=#{self.class.api_key}&connect_display=popup&v=1.0&return_session=true&fbconnect=true&req_perms=#{FacebookBackup.all_permissions.join(',')}#{add_next_parameters(options).join}"
      end
    end
    
    # Checks if associated user can query 'friends' list.  If not, then session 
    # is incorrect (or secret key, or user doesn't exist anymore, etc.)
    def verify_permissions
      user.friends
      true
    rescue 
      @errors = $!
      false
    end
  end
  
  class VaultSession < Session
    # Returns login url + required permissions code
    def login_url_with_perms(options={})
      "https://www.facebook.com/dialog/oauth?client_id=#{@app_id}&redirect_uri=#{options[:next]}&scope=#{FacebookBackup.all_permissions.join(',')}"
    end
  end
end