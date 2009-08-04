# $Id$
# Workling class for aynchronous sending uploaded files to 
# storage cloud.  Currently Amazon S3
  
require 'benchmark'

class UploadsWorker < Workling::Base
  # content (media) uploader to S3
  def upload_content_to_cloud(payload)
    logger.debug "Upload worker got payload #{payload.inspect}"
    return unless content = Content.find(payload[:id])
    
    begin
      content.start_cloud_upload!
  
      s3 = S3Uploader.new(:media)
      mark = Benchmark.realtime do
        s3.upload(content.full_filename, content.public_filename, content.content_type)
      end
      logger.debug "Uploaded content in #{mark} seconds"
      
      content.update_attributes(:s3_key => s3.key)    
      content.finish_cloud_upload!
    rescue 
      logger.error "Exception uploading to S3: #{$!}"
      content.update_attributes(:processing_error_message => $!.to_s)
      content.processing_error!
    end
  end
end
