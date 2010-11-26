module Mogli

  class FbAppClient < Client

    def initialize
      @config = FbAppClient::load_config
      @callback_url = @config['callback_url'] if @config['callback_url']
      @callback_url = 'http://' + @config['tunnel']['public_host'] + ':' + @config['tunnel']['public_port'].to_s unless @callback_url
      @callback_url += defined?(facebook_api_path) ? facebook_api_path : '/'

      raise 'Could not get access token' unless init_access_token

      super(@access_token)
    end

    def self.authorize_url(params = {}, permissions = 'publish_stream')
      params['api_key'] = load_config['api_key']
      params['ext_perm'] = permissions
      'http://www.facebook.com/authorize.php?' + params_to_str(params)
    end

    def old_api(method, params = {})
      url = 'https://api.facebook.com/method/' + method
      url += '?' + params_to_str(params) unless params.empty?
      data = self.class.get(url)
      error = data['error_response']
      raise 'Exception: (#' + error['error_code'] + ') ' + error['error_msg'] if error
      data
    end

    private

    def self.load_config
      YAML.load_file(File.join(RAILS_ROOT,'config','facebooker.yml'))[RAILS_ENV]
    end

    def init_access_token
      return @access_token if @access_token
      url = Authenticator.new(@config['app_id'].to_s,@config['secret_key'],@callback_url).access_token_url('')
      data = self.class.post(url, :body => {
              :type => 'client_cred',
              :client_id => @config['app_id'].to_s,
              :client_secret => @config['secret_key']
      })
      return @access_token = data[Regexp.new('^access_token=(.+)$'),1]
    end

    def params_to_str(params, join_token = true)
      init_access_token if join_token && !@access_token
      params['access_token'] = @access_token if @access_token && join_token
      FbAppClient::params_to_str(params)
    end

    def self.params_to_str(params)
      params.inject('') do |result,param|
        result += '&' unless result.empty?
        value = param[1].is_a?(String) ? param[1] : param[1].to_json
        result += param[0].to_s + '=' + CGI.escape(value)
      end
    end
  end

end