# $Id$

require 'benchmark'

class EmailsWorker < Workling::Base
  include WorklingHelper
  
  # content (media) uploader to S3
  def process_backup_email(payload)
    logger.info "EmailsWorker got payload #{payload.inspect}"
    return unless email = safe_find {
      BackupEmail.find(payload[:id])
    }
    begin
      email.start_cloud_upload!
      
      mark = Benchmark.realtime do
        uploader = S3Uploader.create(:email) # Needs to be singleton for performance
        email.upload_to_s3(uploader)
      end
      logger.info "Uploaded email in #{mark} seconds"
      
      email.finish_cloud_upload!
    rescue 
      email.cloud_upload_error $!.to_s
      logger.error "Exception in #{self.class.to_s}: " + $!
    end
  end
end
