# $Id$
# Workling class for aynchronous sending uploaded files to 
# storage cloud.  Currently Amazon S3
  
require 'benchmark'
require 'workling_helper'

class UploadsWorker < Workling::Base
  include WorklingHelper
  
  # content (media) uploader to S3
  def upload_content_to_cloud(payload)
    logger.debug "Upload worker got payload #{payload.inspect}"
    return unless content = safe_find {
      klass = payload[:class]
      klass.constantize.find(payload[:id])
    }
    
    begin
      content.start_cloud_upload!
  
      s3 = S3Uploader.create(:media)
      mark = Benchmark.realtime do
        s3.upload(content.full_filename, content.public_filename, :content_type => content.content_type)
      end
      logger.debug "Uploaded content in #{mark} seconds"
      
      content.update_attribute(:s3_key, s3.key)    
      content.finish_cloud_upload!
    rescue 
      logger.error "Exception uploading to S3: #{$!}"
      content.cloud_upload_error $!.to_s
    end
  end
end
