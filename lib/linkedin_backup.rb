# $Id$

module LinkedinBackup
  class << self
    def load_config
      YAML.load_file(File.join(Rails.root, 'config', 'linkedin.yml'))[Rails.env] rescue nil || {}
    end
    
    # Date string builder from hash
    def build_date_from_year_month(data)
      dt = data['year']
      if data['month']
        dt +=  '-' + data['month'] + '-1'
      end
      dt
    end
  end
  
  module OAuth
    class << self
      attr_reader :access_token

      # Returns linkedinOAuth::Client client object
      def oauth_client(options = {})
        @@linkedin_config ||= LinkedinBackup.load_config
        
        @key = @@linkedin_config['consumer_key']
        @secret = @@linkedin_config['consumer_secret']
        
        @client = Linkedin2::Consumer.new(@key, @secret,options )
      end

      # Using oauth method
      def account_authenticated(consumer, oauth_verifier)
        # Exchange the request token for an access token.
        @client = consumer.access_token(oauth_verifier.to_s)
      end

      def screen_name(consumer)
        # How will calling these methods twice do anything??
        # Did you mean unless ...?
        if (consumer.get_first_name.nil?)
          first_name = consumer.get_first_name
        end
        if (consumer.get_last_name.nil?)
          last_name = consumer.get_last_name
        end
        return first_name.to_s + ' ' + last_name.to_s
      end

      def authorization(access_token,secret_access_token,options={})
	      @client  = oauth_client()
 	      @client.set_access_token(access_token,secret_access_token)
        @client
      end
    end
  end
end
