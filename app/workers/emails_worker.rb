# $Id$

require 'benchmark'

class EmailsWorker < Workling::Base
  include WorklingHelper
  
  # content (media) uploader to S3
  def process_backup_email(payload)
    logit 'EmailsWorker', "got payload #{payload.inspect}"
    return unless email = safe_find {
      BackupEmail.find(payload[:id])
    }
    begin
      email.start_cloud_upload!
      
      mark = Benchmark.realtime do
        uploader = S3Uploader.create(:email) # Needs to be singleton for performance
        email.upload_to_s3(uploader)
      end
      logit 'EmailsWorker', "Uploaded email in #{mark} seconds"
      
      email.finish_cloud_upload!
    rescue 
      email.cloud_upload_error $!.to_s
      logit 'EmailsWorker', "Exception in #{self.class.to_s}: " + $!
    end
  end
end
