# $Id$

# Simple wrapper to AMQP driver lib code.  Handles connecting to ampq server
# Stores MQ name contsants

require 'mq'

module MessageQueue   
  module Backup
    Exchange          = 'backups'
    WorkerExchange    = 'backup_workers'
    WorkerTopicQueue  = 'backup_job'
    PendingJobsQueue  = 'pending_backups'
    FeedbackQueue     = 'ruote_backup_feedback'
  end
  
  class << self
    include Backup
    
    ConfigPath = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'config')
    DefaultConfig = 'amqp.yml'
    DefaultEnv = 'production'
    
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
    def start(connect_settings=connect_params)
      if block_given? 
        AMQP.start(connect_settings) { yield }
      else
        AMQP.start(connect_settings)
      end
    end
      
    # Stops current reactor loop
    def stop_loop
      AMQP.stop { EM.stop_event_loop }
    end
    
    def create_connection(connect_settings)
      # Connection to RabbitMQ using AMQP driver
      AMQP.connect(connect_settings) do |conn|
        @@connection = conn
        MQ.new(@@connection)
      end
    end
    
    def pending_backup_jobs_queue
      @@bu_xchange ||= MQ.fanout(Exchange)
      MQ.queue(PendingJobsQueue).bind(@@bu_xchange)
    end
    
    def backup_worker_topic_route(site)
      ['worker', site].join('.')
    end
    
    def backup_worker_topic
      MQ.new.topic(WorkerExchange)
    end
    
    def backup_worker_subscriber_queue(site, queue=WorkerTopicQueue)
      MQ.queue(queue, :durable => true).bind(backup_worker_topic, :key => backup_worker_topic_route(site))
    end
    
    def create_topic_queue(channel, queue, options={})
      #@xchange = MQ.new.topic(@channel, :fanout, 'all queues')
      MQ::Queue.new(@channel, queue).bind(@xchange)
    end
  end
end