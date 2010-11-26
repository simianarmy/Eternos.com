module Notificator
  #base notifier class
  class Actor
    attr_reader :logger
    @target = nil

    def initialize
      @logger = Notificator::Logger.new
    end

    def logger= logger
      @logger = logger if logger.is_a?(Notificator::Logger)
    end

    def target= id
      @target = Target.new id
    end

    def set_logger_target
      @logger.target = @target unless @logger.target?
    end

    def before_notify
      set_logger_target
      @logger.before
    end

    def after_notify
      set_logger_target
      @logger.after
    end
    
    def notify
      set_logger_target
      @logger.info 'Performing #{target}'
    end
  end
end