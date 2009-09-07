# $Id$

require 'benchmark'

class EmailsWorker < Workling::Base
  # content (media) uploader to S3
  def process_backup_email(payload)
    logger.debug "EmailsWorker got payload #{payload.inspect}"
    begin
      email = BackupEmail.find(payload[:id])
    rescue ActiveRecord::StatementInvalid => e
      # Catch mysql has gone away errors
      if e.to_s =~ /away/
        ActiveRecord::Base.connection.reconnect! 
        retry
      end
    end
    
    begin
      uploader = S3Uploader.new(:email)
      email.start_cloud_upload!
      
      mark = Benchmark.realtime do
        email.upload_to_s3(uploader)
      end
      logger.debug "Uploaded email in #{mark} seconds"
      
      email.finish_cloud_upload!
    rescue 
      logger.error "Exception uploading to S3: #{$!}"
      email.cloud_upload_error $!.to_s
    end
  end
end
