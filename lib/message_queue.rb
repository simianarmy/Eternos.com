# $Id$

# Simple wrapper to AMQP driver lib code.  Handles connecting to ampq server
# Stores MQ name contsants

require 'mq'

module MessageQueue
  module Backup
    Exchange                = 'backups'
    DirectExchange          = 'backup_processing'
    WorkerTopicExchange     = 'backup_workers'
    WorkerTopicQueue        = 'backup_job'
    WorkerLongJobQueue      = 'long_backup_job'
    PendingJobsQueue        = 'pending_backups'
    FeedbackQueue           = 'ruote_backup_feedback'
    EmailUploadQueue        = 'backup_email_upload'
  end
  
  class << self
    include Backup
    
    ConfigPath = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'config')
    DefaultConfig = 'amqp.yml'
    DefaultEnv = defined?(RAILS_ENV) ? RAILS_ENV : 'dunno'
    
    # Return mq server connection settings in a hash
    def connect_params(config_file=DefaultConfig, env=DefaultEnv)
      f = File.join(ConfigPath, config_file)
      begin
        @conf ||= YAML.load_file(f)
        @conf[env].symbolize_keys!
      rescue
        raise("Unable to load mq config file: #{f}: " + $!)
      end
    end
  
    # Connects to amqp server and returns channel object
    # Must be called from within EventMachine's 'reactor', otherwise it will raise
    # an exception
    # ex. EM.run {
    #   MessageQueue.connect {|channel| ...}
    # }
    # or EM.run { channel = MessageQueue.connect }
  
    def connect(connect_settings=connect_params)
      @@channel = create_connection(connect_settings)
      if block_given?
        yield @@channel
      else
        @@channel
      end
    end

    # Connects and runs block
    def start(connect_settings=connect_params, &block)
      puts "=> AMQP connecting to #{connect_settings[:host]}#{connect_settings[:vhost]}"
      if block_given?
        AMQP.start(connect_settings) { block.call }
      else
        Thread.new do
          EM.run { AMQP.start(connect_settings) }
        end
      end
    end
      
    # Stops current reactor loop
    def stop_loop
      AMQP.stop { EM.stop_event_loop }
    end
    
    def stop
      AMQP.stop { EM.stop }
    end
    
    def create_connection(connect_settings)
      # Connection to RabbitMQ using AMQP driver
      AMQP.connect(connect_settings) do |conn|
        @@connection = conn
        MQ.new(@@connection)
      end
    end
    
    # Runs code block inside em reactor.
    # Helpful for one-time execution where caller doesn't know if em started 
    # or not.
    def execute(connect_settings=connect_params, &block)
      if EM.reactor_running?
        Rails.logger.debug "MessageQueue: EM reactor already running"
        yield
      else
        Rails.logger.debug "MessageQueue: Starting EM reactor"
        start(connect_settings) do
          block.call
          stop
        end
      end
    end
    
    def pending_backup_jobs_queue
      # Memoize dat
      @@pbj_q ||= MQ.queue(PendingJobsQueue).bind(MQ.fanout(Exchange))
    end
    
    def backup_worker_topic_route(site)
      ['worker', site].join('.')
    end
    
    def backup_worker_topic
      @@topic_ex ||= MQ.topic(WorkerTopicExchange)
    end
    
    def backup_worker_direct
      @@direct_ex ||= MQ.direct(DirectExchange, :durable => true)
    end
    
    def backup_worker_subscriber_queue(site)
      MQ.queue('backup_worker').bind(backup_worker_topic, :key => backup_worker_topic_route(site))
    end
    
    def long_backup_worker_queue
      @@long_backup ||= MQ.queue(WorkerLongJobQueue).bind(backup_worker_direct)
    end
    
    def email_upload_queue
      @@eu_q ||= MQ.queue(EmailUploadQueue).bind(backup_worker_direct)
    end
    
    def create_topic_queue(channel, queue, options={})
      #@xchange = MQ.new.topic(@channel, :fanout, 'all queues')
      MQ::Queue.new(@channel, queue).bind(@xchange)
    end
  end
end

