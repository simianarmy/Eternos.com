# $Id$

require 'twitter_oauth'
require 'crack/json' # for just json

module TwitterBackup
  class << self
    attr_reader :access_token
    
    def oauth_client
       @@twitter_config ||= YAML.load_file(File.join(RAILS_ROOT, 'config', 'twitter_oauth.yml')) rescue nil || {}
       @client = TwitterOAuth::Client.new(
        :consumer_key => @@twitter_config['consumer_key'],
        :consumer_secret => @@twitter_config['consumer_secret']
       )
    end
    
    # Using oauth method
    def account_authenticated?(request_token, secret_token, oauth_verifier)
      # Exchange the request token for an access token.
      @access_token = oauth_client.authorize(request_token, secret_token, :oauth_verifier => oauth_verifier)
      @client.authorized?
    end
    
    # Using HTTPAuth w/ username/password
    def account_authenticated_httpauth?(login, password)
      Twitter::Base.new(Twitter::HTTPAuth.new(login, password)).verify_credentials
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