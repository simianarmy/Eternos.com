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


class S3Uploader
  
  S3_CONFIG = YAML.load_file(File.join(RAILS_ROOT, 'config', 'amazon_s3.yml'))[RAILS_ENV]
  
  def initialize(file_name, public_path, content_type)
    @bucket_name = S3_CONFIG['bucket_name']
    @file_name = file_name
    @public_path = public_path
    @content_type = content_type
  end
  
  def connect
    AWS::S3::Base.establish_connection!(
      :access_key_id     => S3_CONFIG['access_key_id'],
      :secret_access_key => S3_CONFIG['secret_access_key'],
      :server            => S3_CONFIG['server'],
      :use_ssl           => S3_CONFIG['use_ssl']
    )
  end

  def url
    s3_protocol = S3_CONFIG[:use_ssl] ? 'https://' : 'http://'
    s3_hostname = S3_CONFIG[:server] || AWS::S3::DEFAULT_HOST
    s3_port     = S3_CONFIG[:use_ssl] ? 443 : 80

    File.join(s3_protocol + s3_hostname + ":#{s3_port}", @bucket_name, @public_path)
  end
  
  
  def upload(boom = false)
    raise "Boom" if boom
    connect
    AWS::S3::S3Object.store(@public_path, 
                            open(@file_name), 
                            @bucket_name, 
                            #:access => :public_read,
                            :content_type => @content_type)
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
          store_without_cache_control(key, data, bucket, options)
        end

        alias_method_chain :store, :cache_control
      end
    end
  end
end
