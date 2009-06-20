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
  class Media < AWS::S3::S3Object
    Bucket = 'eternos.com-media_' + RAILS_ENV
    
    set_current_bucket_to Bucket
  
    class << self
      def to_s
        Bucket
      end
      
      def find
        AWS::S3::Bucket.find(Bucket)
      end
    end
  end
end

class S3Uploader
  attr_accessor :bucket
  
  S3ConfigFile = File.join(RAILS_ROOT, 'config', 'amazon_s3.yml')
  
  # Initialize with some kind of bucket.  Options are
  # :media
  
  def initialize(bucket=nil)
    @bucket = case bucket
    when :media, nil
      S3Buckets::Media
    end
    connect
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

  def url(key=@key_name)
    s3_protocol = config[:use_ssl] ? 'https://' : 'http://'
    s3_hostname = config[:server] || AWS::S3::DEFAULT_HOST
    s3_port     = config[:use_ssl] ? 443 : 80

    File.join(s3_protocol + s3_hostname + ":#{s3_port}", bucket.to_s, key)
  end
  
  
  def upload(file_path, file_name, content_type)
    @key_name = file_name
    RAILS_DEFAULT_LOGGER.info "S3Uploader: uploading #{file_path} => #{file_name} to bucket: #{@bucket}"
    @bucket.store(file_name, open(file_path), :content_type => content_type)
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
        # def store_with_cache_control(key, data, bucket = nil, options = {})
        #           if (options['Cache-Control'].blank?)
        #             options['Cache-Control'] = 'max-age=315360000'
        #           end
        #           # If bucket calls store, no bucket arg so it must be options hash
        #           if bucket && bucket.kind_of?(Hash)
        #             store_without_cache_control(key, data, options)
        #           else
        #             store_without_cache_control(key, data, bucket, options)
        #           end
        #         end
        #         
        #         alias_method_chain :store, :cache_control
      end
    end
  end
end
