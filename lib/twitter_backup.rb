# $Id$

# Supports number of twitter gems 

module TwitterBackup
  # Uses TwitterOAuth::Client object from twitter_oauth gem
  class << self
    def load_config
      YAML.load_file(File.join(RAILS_ROOT, 'config', 'twitter_oauth.yml')) rescue nil || {}
    end
  end
  
  module OAuth
#    require 'twitter_oauth'
    
    class << self
      attr_reader :access_token

      # Returns TwitterOAuth::Client client object
      def oauth_client
        @@twitter_config ||= TwitterBackup.load_config
        opts = {
          :consumer_key => @@twitter_config['consumer_key'],
          :consumer_secret => @@twitter_config['consumer_secret']
        }
        @client = TwitterOAuth::Client.new(opts)
      end

      # Using oauth method
      def account_authenticated?(request_token, secret_token, oauth_verifier)
        # Exchange the request token for an access token.
        @access_token = oauth_client.authorize(request_token, secret_token, :oauth_verifier => oauth_verifier)
        @client.authorized?
      end

      def screen_name(token=access_token)
        response = token.get '/account/verify_credentials.json'
        if response.body 
          json = Crack::JSON.parse(response.body)
          RAILS_DEFAULT_LOGGER.debug "verify_credentials = #{json.inspect}"
          json['screen_name']
        end
      end
    end
  end
  
  # Uses Twitter::Base object
  module Twitter
#    require 'twitter'
    
    class << self
      # Returns Twitter::Base object from oauth credentials
      def oauth_client(token, secret)
        @@twitter_config ||= TwitterBackup.load_config
        oauth = ::Twitter::OAuth.new(@@twitter_config['consumer_key'], @@twitter_config['consumer_secret'])
        oauth.authorize_from_access(token, secret)
        @client = ::Twitter::Base.new(oauth)
      end
      
      def http_client(username, password)
        @client = ::Twitter::Base.new(::Twitter::HTTPAuth.new(username, password))
      end
      
     
      def account_authenticated?
        @client.verify_credentials
      end
    end
  end
end