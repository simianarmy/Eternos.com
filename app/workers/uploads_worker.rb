# $Id$
# Workling class for aynchronous sending uploaded files to 
# storage cloud.  Currently Amazon S3

require 's3_uploader'
  
class UploadsWorker < Workling::Base
  
  def upload_to_cloud(payload)
    return unless content = Content.find(payload[:id])
    
    begin
      content.start_cloud_upload!
      
      s3 = S3Uploader.new(content.full_filename, content.public_filename, content.content_type)
      s3.upload
      content.update_attributes(:cdn_url => s3.url)
      
      content.finish_cloud_upload!
    rescue 
      logger.error "Exception uploading to S3: #{$!}"
      content.update_attributes(:processing_error_message => $!.to_s)
      content.processing_error!
    end
  end

end
