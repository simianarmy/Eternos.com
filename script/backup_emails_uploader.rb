# $Id$

# backup_emails_uploader.rb [DISABLE_AMQP=1] [num_workers]

# Consumes backup-email message queue jobs.
# Forks a number of message queue subscriber workers to upload a number of 
# email files to an Amazon S3 storage.  Each fork reuses S3 connection 
# in order to minimize expensive connect operation.
# Uploads must be run in simultaneous processes in order to manage upload 
# batches of 10K+ files in a reasonable amount of time, with limited resource
# usage.

# Prevent Rails env from starting AMQP thread
DisableAMQPStart = true

require 'rubygems'
require 'active_record'
require File.dirname(__FILE__) + '/../lib/message_queue'
#require File.dirname(__FILE__) + '/../app/models/backup_email'

# For ack to work appropriatly you must shutdown AMQP gracefully,
# otherwise all items in your queue will be returned
Signal.trap('INT') {
  unless EM.forks.empty?
    EM.forks.each do |pid|
      Process.kill('KILL', pid)
    end
  end
  AMQP.stop{ EM.stop }
  exit(0)
}
Signal.trap('TERM') {
  unless EM.forks.empty?
    EM.forks.each do |pid|
      Process.kill('KILL', pid)
    end
  end
  AMQP.stop{ EM.stop }
  exit(0)
}

# spawn workers
workers = ARGV[0] ? (Integer(ARGV[0]) rescue 1) : 1
puts "workers: #{workers}"
EM.fork(workers) do
  MessageQueue.start do
    class Processor

      attr_reader :options

      def initialize(options)
        @options = options
        puts "Loading Rails..."
        require File.dirname(__FILE__) + '/../config/environment'
      end

      def process_emails
        uploader = S3Uploader.new(:email)
        queue = MessageQueue.email_upload_queue

        run_process(queue) do |id|
          begin
            email = BackupEmail.find(id.to_i) 
            email.upload_to_s3(uploader)
          rescue Exception => e
            puts "error uploading email #{id}: " + $!
            puts e.backtrace
            false
          end
        end
      end

      protected
      
      def run_process(queue, &block)
        queue.subscribe(:ack => true) { |headers, payload|
          data = ActiveSupport::JSON.decode(payload)
          puts "decoded payload: #{data.inspect}"
          # send job back to queue if it failed?
          if block.call(data['id'])
            puts "sending ack"
            headers.ack
          end
        }
      end
    end

    Processor.new(ENV).process_emails
  end # end AMQP.start
end # end EM.fork

# wait on forks
while !EM.forks.empty?
  sleep(5)
end
puts "Forks empty. Exiting"