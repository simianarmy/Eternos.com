module Notificator
  class Logger
    @target = nil

    def target= target
      @target = target
    end

    def target?
      !@target.nil?
    end

    def before
      puts (@target.nil? ? '' : (@target.to_s + ': ')) + 'performing new target'
    end

    def info message
      puts (@target.nil? ? message : message.gsub(/#\{target\}/, @target.to_s))
    end

    def after
      puts (@target.nil? ? '' : (@target.to_s + ': ')) + 'notification was sent'
    end
  end
end