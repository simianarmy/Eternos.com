# Id$
# 
# Module for Desktop Facebook App
# App implements:
#  Backup Content
#

require 'facebooker'

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


module FacebookDesktopApp
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
    attr_reader :config, :errors
    
    def self.create(config=nil)
      conf = FacebookDesktopApp.load_config(config)
      super(conf['api_key'], conf['secret_key'])
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
      "http://www.facebook.com/login.php?api_key=#{self.class.api_key}&connect_display=popup&v=1.0&return_session=true&fbconnect=true&req_perms=#{FacebookDesktopApp.all_permissions.join(',')}#{add_next_parameters(options).join}"
    end
    
    # Checks if associated user can query 'friends' list.  If not, then session 
    # is incorrect (or secret key, or user doesn't exist anymore, etc.)
    def verify_permissions
      user.has_permissions? FacebookDesktopApp.backup_permissions
#      user.friends
    rescue 
      @errors = $!
      false
    end
  end
end
    