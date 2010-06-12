# $Id$

module ContentUploader
  # Ensures any unsaved asset on filesystem is saved to cloud.  
  # Deletes assets once they are confirmed as saved to cloud.
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
        end
        t1.join
        puts "Out of thread...stopping EM"
        MessageQueue.stop
      end
    end
    
    def logit(msg)
      Rails.logger.info msg
      puts "ContentUploader: #{Time.now.utc}: #{msg}"
    end
  end
end