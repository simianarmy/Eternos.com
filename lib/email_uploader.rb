# $Id$
#
# Uploads emails files from disk to cloud
# Workaround: Should be done automatically by worklings
# 

module EmailUploader
  class << self
    @@max = 500
    def upload_all
      MessageQueue.start do
        Thread.abort_on_exception = true
        t1 = Thread.new do
          i = 0
          BackupEmail.deleted_at_nil.s3_key_nil.find(:all, :readonly => false, :joins => {:backup_source => :member}, :conditions => ['users.state = ?', 'live']).each do |bu_email|
            if File.exists? bu_email.temp_filename
              puts "Saving #{bu_email.temp_filename}"
              # Try to upload
              bu_email.update_attribute(:state, 'pending')
              bu_email.stage!
              puts "email staged...hopefully uploading now."
              #sleep(0.1)
              if ((i += 1) % @@max) == 0
                puts "#{i} done, sleeping..."
                sleep(10)
              end
            end
          end # BackupEmail.each
          puts "Done."
        end # Thread.new
        t1.join
        puts "Out of thread"
        MessageQueue.stop
      end
    end
  end

  def logit(msg)
    Rails.logger.info msg
    puts "EmailUploader: #{Time.now.utc}: #{msg}"
  end
end