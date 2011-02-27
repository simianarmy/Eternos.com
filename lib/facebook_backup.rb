# Support files for backup daemons
require File.join(File.dirname(__FILE__), 'facebook_user_profile')
require File.join(File.dirname(__FILE__), 'facebook_proxy_objects')
# Requires necessary for backup app
require 'facebooker'
require 'mogli'

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
    attr_reader :config, :errors, :app_id, :access_token, :api
    
    def self.create(config=nil)
      conf = FacebookBackup.load_config(config)
      
      me = super(conf['api_key'], conf['secret_key'])
      # Add additional config values
      me.instance_variable_set("@app_id", conf['app_id']||'')
      me.instance_variable_set("@access_token", conf['access_token']||'')
      me.instance_variable_set("@api", conf['api']||'')
      me
    end
    
    # IMPORTANT - Needed to override post to always use the session_key!
    # If this is not set then we will get InvalidSignature errors for every desktop request
    def post(method, params = {}, use_session=false)
      if method == 'facebook.profile.getFBML' || method == 'facebook.profile.setFBML'
        raise NonSessionUser.new("User #{@uid} is not the logged in user.") unless @uid == params[:uid]
      end
      Rails.logger.debug "Facebooker::Session::Desktop::post use_session=true"
      super(method, params, true)
    end
    
    def connect(session, uid, timeout, secret)
      Rails.logger.debug "Facebooker::Session::Desktop::connect with #{session}, #{uid}, #{timeout}, #{secret}"
      secure_with!(session, uid, timeout, secret)
    end

    # Returns login url + required permissions code
    def login_url_with_perms(options={})
      # If oauth-style authentication
      if self.api == 'oauth'
        "/facebook_oauth/new"
        #"https://www.facebook.com/dialog/oauth?client_id=#{app_id}&redirect_uri=#{CGI::escape(options[:next])}&scope=#{FacebookBackup.all_permissions.join(',')}"
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
  
  # Helper class for Facebook apps that use the OpenGraph API
  # Uses Mogli gem for opengraph communication with facebook
  class OpenGraphApp
    attr_reader :app_id, :app_secret, :fb_config, :session, :user

    class InvalidClientException < Exception; end
    
    # Helper for profile value fetching
    # TODO: Fork mogli & add there
    def self.user_profile_value(user, attribute)
      if user.respond_to?(attribute)
        val = user.send(attribute) 
        # val itself could be a Mogli::Page object
        val.class == Mogli::Page ? val.to_s : val
      end
    end
    
    # Call with application id so that proper facebook configuration file will be used
    def initialize(app)
      config = load_facebook_yaml(app)
      @app_id     = config['app_id']
      @app_secret = config['secret_key']
      @session    = nil
      @user       = nil
    end

    # Creates 'session' for user's access token.  Recreates if token has changed. 
    # Caches if unchanged.
    def session(access_token)
      if @session.nil? || (@session.access_token != access_token)
        @session = ::Mogli::Client.new access_token
        @user = ::Mogli::User.find("me", @session)
      end
      @session
    end

    # Returns Mogli user for an authenticated user's access token.
    # If no access token passed, returns previously fetched user, or raises error
    def user(access_token=nil)
      # create client from access token if passed
      session(access_token) if access_token
      @user
    end
    
    # Checks if associated user has offline permissions
    def verify_permissions
      user.has_permission? :offline_access
    rescue 
      @errors = $!
      false
    end
    
    protected
    
    # Helper to read vault facebook app settings.  Will be moved to lib once I figure out 
    # organization
    def load_facebook_yaml(app)
      config = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","facebook.#{app.to_s}.yml"))).result)[Rails.env]
      @fb_config ||= config.with_indifferent_access
    end
  end
end