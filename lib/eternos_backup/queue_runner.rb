# $Id$

# Implements common backup queue methods

module EternosBackup
  module QueueRunner
    AMQP_BACKUP_CONFIG = 'amqp.yml'
    
    # Run block inside EM reactor and connected to backup AMQP server
    def run_backup_job(&block)
      MessageQueue.start(MessageQueue.connect_params(AMQP_BACKUP_CONFIG)) do
        yield
        MessageQueue.stop
      end
    end
  end
end