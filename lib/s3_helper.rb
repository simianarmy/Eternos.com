# $Id$
#!/usr/bin/env ruby
#---
# Excerpted from "Advanced Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
#---

require 'rubygems'
require 'aws/s3'
require 'yaml'
require 'singleton'

module S3Buckets
  # Eternos S3 Buckets
  # 
  # Supported buckets by symbol
  # :email
  # :media
  # :screencap
  
  class EternosBucket < AWS::S3::S3Object
    class_inheritable_accessor :eternos_bucket_name
    class_inheritable_accessor :access_level
    
    class << self
      def init
        tries = 0
        begin
          @@current_bucket = AWS::S3::Bucket.find(eternos_bucket_name)
        rescue
          AWS::S3::Bucket.create(eternos_bucket_name)
          tries += 1
          retry if tries < 3
        end
      end

      def to_s
        eternos_bucket_name
      end
      
      def size
        object.size
      end
      
      def object
        @@current_bucket
      end
      
      # Returns full url to Amazon resource using relative protocol trick
      def url(key)
        '//s3.amazonaws.com/' + eternos_bucket_name + '/' + key
      end
      
      # Returns url to Amazon resource with aws key/secret
      def encoded_url(key)
        s3_config = S3Connection.new.s3_config
        "http://#{CGI::escape(s3_config['access_key_id'])}:#{CGI::escape(s3_config['secret_access_key'])}@#{eternos_bucket_name}.s3.amazonaws.com/#{key}"
      end
      
    end
  end

  class MediaBucket < EternosBucket
    self.eternos_bucket_name = 'eternos.com-media_' + RAILS_ENV
    self.access_level = :public_read
    
    set_current_bucket_to eternos_bucket_name
  end
  
  class EmailBucket < EternosBucket
    self.eternos_bucket_name = 'eternos.com-email_' + RAILS_ENV
    self.access_level = :private
    
    set_current_bucket_to eternos_bucket_name
  end
  
  class ScreencapBucket < EternosBucket
    self.eternos_bucket_name = 'eternos.com-screencap_' + RAILS_ENV
    self.access_level = :public_read
    
    set_current_bucket_to eternos_bucket_name
  end
end

# Base class for S3 helper classes, should not have to create directly
class S3Connection
  S3ConfigFile = File.join(RAILS_ROOT, 'config', 'amazon_s3.yml')
  DefaultBucket = :media
  
  attr_reader :s3_config
  attr_reader :bucket_type, :errors
  
  def set_bucket(sym)
    @bucket_type = sym
  end
  
  def bucket(tp=bucket_type)
    @_buckets[tp] ||= init_bucket(tp)
  end
  
  def object(tp=bucket_type)
    @_buckets[tp].object
  end
  
  def connect(conf=config)
    AWS::S3::Base.establish_connection!(
      :access_key_id     => conf['access_key_id'],
      :secret_access_key => conf['secret_access_key']
     # :use_ssl           => conf['use_ssl']
    ) unless AWS::S3::Base.connected?
  end

  def initialize(tp=DefaultBucket)
     @_buckets = {}
     @bucket_type = tp
     connect
  end
  
  protected
   
  def config(config=S3ConfigFile)
    @s3_config ||= YAML.load_file(config)[RAILS_ENV]
  end
  
  # finds/creates & returns bucket object
  def init_bucket(bucket_type=nil)
    @_buckets[bucket_type] = case bucket_type
    when :media, nil
      S3Buckets::MediaBucket
    when :email
      S3Buckets::EmailBucket
    when :screencap
      S3Buckets::ScreencapBucket
    end
    @_buckets[bucket_type].init
    @_buckets[bucket_type]
  end  
end

# S3 Download class - singleton to avoid multiple expensive establish_connection calls

class S3Downloader < S3Connection
  #include Singleton
  
  def fetch(key)
    bucket.find key
  end
  
  def fetch_value(key)
    bucket.value key
  end
  
  def fetch_stream(key)
    bucket.stream(key) do |chunk|
      yield chunk
    end
  end
end
  
class S3Uploader < S3Connection
  include Singleton
  
  attr_accessor :s3_key
  
  # Helper to access singleton & set bucket at the same time
  def self.create(bucket)
    returning self.instance do |me|
      me.set_bucket bucket
    end
  end
  
  def self.path_to_key(path)
    # Strip leading /
    path.sub(/^\//, '')
  end

  def key
    # Strip leading / if key is public path
    raise "S3 Key not defined" unless s3_key
    self.class.path_to_key s3_key
  end
  
  def url(key=s3_key)
    s3_protocol = config[:use_ssl] ? 'https://' : 'http://'
    s3_hostname = config[:server] || AWS::S3::DEFAULT_HOST
    s3_port     = config[:use_ssl] ? 443 : 80

    File.join(s3_protocol + s3_hostname + ":#{s3_port}", bucket.to_s, key)
  end
  
  # Stores file to S3 current bucket.  Returns stored object's key
  def upload(file_path, file_name, opts={})
    opts.reverse_merge! :access => bucket.access_level
    
    RAILS_DEFAULT_LOGGER.info "S3Uploader: uploading #{file_path} => #{file_name} to bucket: #{bucket} with headers: #{opts.inspect}"
    begin
      bucket.store(file_name, open(file_path), nil, opts)
      self.s3_key = file_name
      key
    rescue AWS::S3::ResponseError => error
      @errors = error.response.code.to_s + " " + error.message
      RAILS_DEFAULT_LOGGER.warn "Error uploading to S3: #{@errors}"
      false
    end
  end
  
  def store(name, value)
    bucket.store(name, value)
  end
end

# Adds Cache-Control to store call in order to save on S3 bandwidth
# We want Amazon to serve all of our images with a Cache-Control or Expires header set to a point in the very far future. This will avoid unnecessary HTTP requests on subsequent page views, making the site faster for users and consuming less bandwidth.
module AWS
  module S3
    class S3Object
      class << self
        def store_with_cache_controlzz(key, data, bucket = nil, options = {})
          if (options['Cache-Control'].blank?)
            options['Cache-Control'] = 'max-age=315360000'
          end
          # If bucket calls store, no bucket arg so it must be options hash
          if bucket && bucket.kind_of?(Hash)
            store_without_cache_control(key, data, options)
          else
            store_without_cache_control(key, data, bucket, options)
          end
        end

        #alias_method_chain :store, :cache_control
      end
    end
  end
end

# Fix for:
# right_http_connection 1.2.4 (right_http_connection-1.2.4/lib/net_fix.rb)
# Original version of send_request_with_body_stream takes 5 arguments, but rewritten one takes only 4.

# Make Net::HTTPGenericRequest#send_request_with_body_stream match 
# RightHttpConnection's implementation

# When streaming data up, Net::HTTPGenericRequest hard codes a chunk size of 1k. For large files this
# is an unfortunately low chunk size, so here we make it use a much larger default size and move it into a method
# so that the implementation of send_request_with_body_stream doesn't need to be changed to change the chunk size (at least not anymore
# than I've already had to...).
module Net
  class HTTPGenericRequest
    def send_request_with_body_stream(sock, ver, path, f, send_only = nil)
      raise ArgumentError, "Content-Length not given and Transfer-Encoding is not `chunked'" unless content_length() or chunked?
      unless content_type()
        warn 'net/http: warning: Content-Type did not set; using application/x-www-form-urlencoded' if $VERBOSE
        set_content_type 'application/x-www-form-urlencoded'
      end
      write_header(sock, ver, path) unless send_only == :body
      unless send_only == :header
        if chunked?
          while s = f.read(chunk_size)
            sock.write(sprintf("%x\r\n", s.length) << s << "\r\n")
          end
          sock.write "0\r\n\r\n"
        else
          while s = f.read(chunk_size)
            sock.write s
          end
        end
      end
    end
    
    def chunk_size
      1048576 # 1 megabyte
    end
  end
end