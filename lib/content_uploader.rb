# $Id$
require 'fileutils'

module ContentUploader
  # Ensures any unsaved asset on filesystem is saved to cloud.  
  # Deletes assets once they are confirmed as saved to cloud.
  # FIXME:
  # Required because AMQP is not good way to pass messages, need 
  # more "robust" (synchronous?) message queue system.
  class << self
    @@max = 500
    def upload_all
      MessageQueue.start do
        Thread.abort_on_exception = true
        t1 = Thread.new do
          i = 0
          Content.deleted_at_nil.s3_key_nil.find(:all, :readonly => false, :joins => :member, :conditions => ['users.state = ?', 'live']).each do |c|
            if File.exists? c.full_filename
              logit "Queuing for upload: #{c.full_filename}"
              c.update_attribute(:state, 'pending')
              c.stage!
              
              if ((i += 1) % @@max) == 0
                puts "#{i} done, sleeping..."
                sleep(5)
              end
            end
          end
          # Look for files in cloud staging directory
          
          Dir.glob(File.join(cloud_staging_dir, '*.jpg')).each do |f|
            fname = File.basename(f)
            logit "Looking for #{fname} in db..."
            if c = Content.filename_eq(fname).first
              logit "Found matching record #{c.id} with S3 key: #{c.s3_key}"
              if c.s3_key
                logit "Deleting #{f}"
                FileUtils.rm(f)
              else
                logit "Scheduling for upload..."
                unless File.exists? c.full_filename
                  logit "Moving file to #{c.full_filename}..."
                  FileUtils.mkdir_p File.dirname(c.full_filename)
                  FileUtils.mv f, c.full_filename
                end
                c.update_attribute(:state, 'pending')
                c.stage!
              end
            else
              logit "Content record not found..."
              # What to do??  Best to look for owning BackupPhoto & tell it to retry
              bps = BackupPhoto.source_url_like(fname)
              if bps && bps.any?
                logit "Retrying download"
                bps.first.download
              else
                logit "BackupPhoto for #{f} not found!"
              end
            end
          end
        end
        t1.join
        puts "Out of thread...stopping EM"
        MessageQueue.stop
      end
    end
    
    def cloud_staging_dir
      AppConfig.s3_staging_dir.first == '/' ? 
        AppConfig.s3_staging_dir : 
        File.join(Rails.root, AppConfig.s3_staging_dir)
    end
    
    def logit(msg)
      Rails.logger.info msg
      puts "ContentUploader: #{Time.now.utc}: #{msg}"
    end
  end
end