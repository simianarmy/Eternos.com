# $Id$

class EmailContent < ActiveRecord::Base
  belongs_to :backup_email
  
  cattr_reader :max_col_size
  @@max_col_size = 100.kilobytes
  
  # Determine how to save raw_email - in-record or in s3
  def save_contents(message_id, raw_email)
    if raw_email.length > self.class.max_col_size
      self.bytes = raw_email.length
      self.s3_key = [message_id, Time.now.to_i.to_s, Time.now.usec.to_s].join(':')
      S3Uploader.new(:email).store(self.s3_key, raw_email)
    else
      self[:contents] = raw_email
    end
  end
  
  def contents
    if self[:contents]
      self[:contents]
    else
      # Fetch from S3
      puts "Stored on S3 key = #{s3_key}"
      "fake data"
    end
  end
end
