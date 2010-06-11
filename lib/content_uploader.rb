# $Id$

module ContentUploader
  # Ensures any unsaved asset on filesystem is saved to cloud.  
  # Deletes assets once they are confirmed as saved to cloud.
  class << self
    def upload_all
      MessageQueue.start do
        Thread.new do
          Content.deleted_at_nil.s3_key_nil.find_each do |c|
            if File.exists? c.full_filename
              c.update_attribute(:state, 'pending')
              begin
                c.stage!
              rescue
                logit "Error staging: " + $!
              end
              sleep(0.5)
            end
          end
          MessageQueue.stop
        end
      end
    end
    
    def logit(msg)
      Rails.logger.info msg
      puts "ContentUploader: #{Time.now.utc}: #{msg}"
    end
  end
end