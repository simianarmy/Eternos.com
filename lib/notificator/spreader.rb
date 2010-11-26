#notification spreader
#should not be rewritten, but configured
#it uses actor to send notification to targets, which could be specific
module Notificator
  class Spreader
    attr_writer :timeout

    def initialize ids, target_class = Target, actor = nil
      @logger = Notificator::Logger.new
      @timeout = 0
      @targets = ids.map {|id| target_class.new(id) }
      @actor = actor.nil? ? Actor.new : actor
    end

    def set_logger logger
      @logger = logger if logger.is_a?(Notificator::Logger)
    end

    def notify
      @targets.each do |target|
        @logger.set_target target
        @logger.before
        @actor.notify target, @logger
        @logger.after
      end
    end
  end
end