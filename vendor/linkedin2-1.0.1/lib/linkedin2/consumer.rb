# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'net/https'

require 'cgi'
require 'base64'
require 'openssl'
require 'hmac-sha1'
require 'uri'
require 'net/http'
require 'cobravsmongoose'

module Linkedin2
  class Consumer
    @@default_options = {
      # Signature method used by server. Defaults to HMAC-SHA1
      :signature_method   => 'HMAC-SHA1',
      # default paths on site. These are the same as the defaults set up by the generators
      :request_token_path => 'https://api.linkedin.com/uas/oauth/requestToken',
      :authorize_path     => 'https://api.linkedin.com/uas/oauth/authorize',
      :access_token_path  => 'https://api.linkedin.com/uas/oauth/accessToken',
      :proxy              => nil,
      # Default http method used for OAuth Token Requests (defaults to :post)
      :http_method   => 'POST',
      :oauth_version => "1.0",
      :oauth_callback => "oob"
    }
    @oauth_requestToken = nil
    @oauth_requestSecretToken = nil
    @oauth_accessToken = nil
    @oauth_accessSecretToken = nil
    @profile = nil
    @user_id = nil

    def initialize(consumer_key, consumer_secret, options = {})
      @key  = consumer_key
      @secret = consumer_secret

      @oauth_nonce = random_number
      @oauth_timestamp = Time.now.to_i;
      # ensure that keys are symbols
      @@default_options = @@default_options.merge(options.inject({}) do |opts, (key, value)|
        opts[key.to_sym] = value
        opts
      end)
    end

    def signature(base_string, consumer_secret,token_secret='')
      secret="#{CGI::escape(consumer_secret)}&#{CGI::escape(token_secret)}"
      CGI::escape(Base64.encode64(HMAC::SHA1.digest(secret,base_string)).chomp.gsub(/\n/,''))
    end

    # make the consumer out of your secret and key
    def random_number
      t = Time.now.to_f / (Time.now.to_f % Time.now.to_i)
      random_seed = t * 1103515245 + 12345;
      ((random_seed / 65536) % 32768).round;
    end
    
    def request_token
      #create base String
      base_str = @@default_options[:http_method] + "&" + CGI::escape(@@default_options[:request_token_path]).to_s + "&"+

      CGI::escape("oauth_callback=") + CGI::escape(CGI::escape(@@default_options[:oauth_callback])).to_s +
      CGI::escape(
      "&oauth_consumer_key=" + @key.to_s  + "&" +
      "oauth_nonce=" + @oauth_nonce.to_s  + "&" +
      "oauth_signature_method=" + @@default_options[:signature_method]  + "&" +
      "oauth_timestamp=" + @oauth_timestamp.to_s  + "&" +
      "oauth_version=" + @@default_options[:oauth_version]
      );
      #create signature
      oauth_signature = signature(base_str,@secret)

      #create Authorization
      authorization = 'OAuth ' +
      'oauth_nonce="' + @oauth_nonce.to_s + '", ' +
      'oauth_callback="' + CGI::escape(@@default_options[:oauth_callback]) + '", ' +
      'oauth_signature_method="' + @@default_options[:signature_method] + '", ' +
      'oauth_timestamp="' + @oauth_timestamp.to_s + '", ' +
      'oauth_consumer_key="' + @key.to_s + '", ' +
      'oauth_signature="' + oauth_signature + '", ' +
      'oauth_version="' + @@default_options[:oauth_version] + '"';
      str_result = http_post(authorization,@@default_options[:request_token_path])
      @oauth_requestToken = get_parameter(str_result)[:oauth_token]
      @oauth_requestSecretToken = get_parameter(str_result)[:oauth_token_secret]
      "https://www.linkedin.com/uas/oauth/authorize?oauth_token=" + @oauth_requestToken
    end

    def access_token(oauth_verify)
      base_str = @@default_options[:http_method] + "&" + CGI::escape(@@default_options[:access_token_path]).to_s + "&"+

      CGI::escape(
      "oauth_consumer_key=" + @key  + "&" +
      "oauth_nonce=" + @oauth_nonce.to_s  + "&" +
      "oauth_signature_method=" + @@default_options[:signature_method]  + "&" +
      "oauth_timestamp=" + @oauth_timestamp.to_s  + "&" +
      "oauth_token=" + @oauth_requestToken.to_s + "&" +
      "oauth_verifier=" + oauth_verify.to_s  + "&" +
      "oauth_version=" + @@default_options[:oauth_version]
      );

      #create signature
      oauth_signature = signature(base_str,@secret.to_s,@oauth_requestSecretToken.to_s)

      authorization = 'OAuth ' +
      'oauth_nonce="' + @oauth_nonce.to_s + '", ' +
      'oauth_signature_method="' + @@default_options[:signature_method] + '", ' +
      'oauth_timestamp="' + @oauth_timestamp.to_s + '", ' +
      'oauth_consumer_key="' + @key.to_s + '", ' +
      'oauth_token="' + @oauth_requestToken.to_s + '", ' +
      'oauth_verifier="' + oauth_verify + '", ' +
      'oauth_signature="' + oauth_signature + '", ' +
      'oauth_version="' + @@default_options[:oauth_version] + '"';
      str_result = http_post(authorization,@@default_options[:access_token_path])
      @oauth_accessToken = get_parameter(str_result)[:oauth_token]
      @oauth_accessSecretToken = get_parameter(str_result)[:oauth_token_secret]
    end
    
    def get_access_token
      @oauth_accessToken
    end
    
    def get_secret_access_token
      @oauth_accessSecretToken
    end

    def set_access_token(access_token,secret_token)
      @oauth_accessToken = access_token
      @oauth_accessSecretToken = secret_token
    end

    def get_infomation (baselink,extension,type = nil)
      type_connection_base_str = nil
      type_connection_link_str = nil
      if (!type.nil?)
        type_connection_base_str = '&type=' + type.upcase
        type_connection_link_str = '?type=' + type.upcase
      end

      base_str = "GET" + "&" + CGI::escape(baselink).to_s + "~"+CGI::escape(extension)+"&" +
      CGI::escape(
      #"count=10"+ "&" +
      "oauth_consumer_key=" + @key.to_s  + "&" +
      "oauth_nonce=" + @oauth_nonce.to_s  + "&" +
      "oauth_signature_method=" + @@default_options[:signature_method]  + "&" +
      "oauth_timestamp=" + (@oauth_timestamp ).to_s  + "&" +
      "oauth_token=" + @oauth_accessToken.to_s + "&" +
      "oauth_version=" + @@default_options[:oauth_version]+
      #"start=0" +"&"
      type_connection_base_str.to_s
      );

      #create signature
      oauth_signature = signature(base_str,@secret.to_s,@oauth_accessSecretToken.to_s)

      authorization = 'OAuth ' +
      'oauth_nonce="' + @oauth_nonce.to_s + '", ' +
      'oauth_signature_method="' + @@default_options[:signature_method] + '", ' +
      'oauth_timestamp="' + (@oauth_timestamp ).to_s + '", ' +
      'oauth_consumer_key="' + @key.to_s + '", ' +
      'oauth_token="' + @oauth_accessToken.to_s + '", ' +
      'oauth_signature="' + oauth_signature + '", ' +
      'oauth_version="' + @@default_options[:oauth_version] + '"';

      http_get(authorization,baselink.to_s + '~'+ extension + type_connection_link_str.to_s )
    end
    
    def get_profile list_field
      if (list_field == 'all')
        list_field ='id,first-name,last-name,headline,location,industry,distance,relation-to-viewer,current-status,current-status-timestamp,current-share,connections,num-connections,num-connections-capped,summary,specialties,proposal-comments,associations,honors,interests,positions,publications:(id,title,publisher,authors,date,url,summary),patents:(id,title,summary,number,status,office,inventors,date,url),languages:(id,language,proficiency),skills:(skill,proficiency,years),certifications:(id,name,authority,number,start-date,end-date),educations,three-current-positions,three-past-positions,num-recommenders,recommendations-received,phone-numbers,im-accounts,twitter-accounts,date-of-birth,main-address,member-url-resources,picture-url'
      end

      @profile = get_infomation('https://api.linkedin.com/v1/people/',':('+ list_field +')')
    end
    
    def get_network_static
       get_infomation('https://api.linkedin.com/v1/people/','/network/network-stats')
    end
    
    def get_network_update(type)
      if (type.upcase == 'NCON')
        data = get_infomation('https://api.linkedin.com/v1/people/','/network/updates','CONN')
        hash = CobraVsMongoose.xml_to_hash(data)
        hash['updates']['update'].delete_if { |update|
          update['update-type']['$'].to_s == 'CONN'.to_s
        }
        return CobraVsMongoose.hash_to_xml(hash)
      else
        return get_infomation('https://api.linkedin.com/v1/people/','/network/updates',type)
      end
    end

    def http_post (oauth_str,link)
      header = {"Authorization" => oauth_str}
      uri = URI.parse(link)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"  # enable SSL/TLS
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.start {
        http.request_post(link,'',  header) { |response|
          return response.body.to_s
        }
      }
    end

    def http_get (oauth_str,link)
      header = {"Authorization" => oauth_str}
      uri = URI.parse(link)

      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"  # enable SSL/TLS
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      end
      http.start {
        http.request_get(link,header) { |response|
          return response.body
        }
      }
    end

    def get_parameter(str)
      array = str.split("&")
      header = {:oauth_token => array[0].split("=")[1],
        :oauth_token_secret =>  array[1].split("=")[1]
      }
    end

    def get_name
      get_profile 'id,first-name,last-name'
      if @profile
        get_first_name << " " << get_last_name
      end
    end
    
    def get_first_name
      if @profile.nil?
        return nil
      end
      doc = REXML::Document.new(@profile)
      doc.elements.each('person') do |ele|
        return ele.elements['first-name'].text
      end
    end

    def get_last_name
      if @profile.nil?
        return nil
      end
      doc = REXML::Document.new(@profile)
      doc.elements.each('person') do |ele|
        return ele.elements['last-name'].text
      end
    end
  end # Consumer
end # Linkedin2

