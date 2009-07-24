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

module S3Buckets
  class EternosBucket < AWS::S3::S3Object
    class_inheritable_accessor :eternos_bucket_name
    
    class << self
      def init
        tries = 0
        begin
          find
        rescue
          create
          tries += 1
          retry if tries < 3
        end
      end

      def to_s
        eternos_bucket_name
      end

      def find
        current_bucket = AWS::S3::Bucket.find(eternos_bucket_name)
      end

      def create
        AWS::S3::Bucket.create(eternos_bucket_name)
      end
    end
  end

  class MediaBucket < EternosBucket
    self.eternos_bucket_name = 'eternos.com-media_' + RAILS_ENV
    set_current_bucket_to eternos_bucket_name
  end
  
  class EmailBucket < EternosBucket
    self.eternos_bucket_name = 'eternos.com-email_' + RAILS_ENV
    set_current_bucket_to eternos_bucket_name
  end

end

class S3Uploader
  attr_reader :bucket
  
  S3ConfigFile = File.join(RAILS_ROOT, 'config', 'amazon_s3.yml')
  
  # Initialize with some kind of bucket.  Options are
  # :media
  
  def self.path_to_key(path)
    # Strip leading /
    path.sub(/^\//, '')
  end
  
  def initialize(bucket=nil)
    connect
    @bucket = case bucket
    when :media, nil
      S3Buckets::MediaBucket
    when :email
      S3Buckets::EmailBucket
    end
    @bucket.init
  end
  
  def config
    @S3_CONFIG ||= YAML.load_file(S3ConfigFile)[RAILS_ENV]
  end
  
  def connect
    AWS::S3::Base.establish_connection!(
      :access_key_id     => config['access_key_id'],
      :secret_access_key => config['secret_access_key']
     # :use_ssl           => config['use_ssl']
    ) unless AWS::S3::Base.connected?
  end

  def key
    # Strip leading / if key is public path
    raise "S3 Key not defined" unless @key_name
    self.class.path_to_key @key_name
  end
  
  def url(key=@key_name)
    s3_protocol = config[:use_ssl] ? 'https://' : 'http://'
    s3_hostname = config[:server] || AWS::S3::DEFAULT_HOST
    s3_port     = config[:use_ssl] ? 443 : 80

    File.join(s3_protocol + s3_hostname + ":#{s3_port}", bucket.to_s, key)
  end
  
  # Stores file to S3 current bucket.  Returns stored object's key
  def upload(file_path, file_name, content_type=nil)
    @key_name = file_name
    opts = {}
    opts[:content_type] = content_type if content_type
    
    RAILS_DEFAULT_LOGGER.info "S3Uploader: uploading #{file_path} => #{file_name} to bucket: #{@bucket}"
    @bucket.store(file_name, open(file_path), opts)
    # Return access key
    key
  end
  
  def store(name, value)
    @bucket.store(name, value)
  end
  
  # a few supporting methods
end

# Adds Cache-Control to store call in order to save on S3 bandwidth
# We want Amazon to serve all of our images with a Cache-Control or Expires header set to a point in the very far future. This will avoid unnecessary HTTP requests on subsequent page views, making the site faster for users and consuming less bandwidth.
module AWS
  module S3
    class S3Object
      class << self
        def store_with_cache_control(key, data, bucket = nil, options = {})
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

        alias_method_chain :store, :cache_control
      end
    end
  end
end
