# $Id$
# Workling class for aynchronous sending uploaded files to 
# storage cloud.  Currently Amazon S3
  
require 'benchmark'

class UploadsWorker < Workling::Base
  # content (media) uploader to S3
  def upload_content_to_cloud(payload)
    return unless content = Content.find(payload[:id])
    
    begin
      content.start_cloud_upload!
      
      s3 = S3Uploader.new(:media)
      s3.upload(content.full_filename, content.public_filename, content.content_type)
      content.update_attributes(:s3_key => s3.key)
      
      content.finish_cloud_upload!
    rescue 
      logger.error "Exception uploading to S3: #{$!}"
      content.update_attributes(:processing_error_message => $!.to_s)
      content.processing_error!
    end
  end

  # email uploader to S3
  def upload_email_to_cloud(payload)
    logger.info "Starting email upload worker"
    return unless email = BackupEmail.find(payload[:id])
    
    # do some validity checks
    if email.uploaded?
      logger.warn "email #{email.id} already uploaded"
      return
    end
    email_file = email.temp_filename
    unless File.exists?(email_file)
      logger.warn "missing raw file (#{email_file}) for email #{email.id}"
      return
    end
    
    begin
      key = email.gen_s3_key
      mark = Benchmark.realtime do
        if S3Uploader.new(:email).upload(email_file, key)
          email.update_attributes(:s3_key => key, :size => File.size(email_file))
          FileUtils.rm email_file
        end
      end
      logger.debug "Uploaded email in #{mark} seconds"
    rescue
      logger.error "error uploading email to cloud: " + $!.to_s
      email.update_attribute(:upload_errors, $!.to_s)
    end
  end
end
