#notification spreader
#should not be rewritten, but configured
#it uses actor to send notification to targets, which could be specific
module Notificator
  class Spreader
    attr_writer :timeout

    def initialize ids, actor = nil
      @timeout = 0
      @ids = ids
      @actor = actor.nil? ? Actor.new : actor
    end

    def notify
      @ids.each do |id|
        @actor.target = id
        @actor.before_notify
        @actor.notify
        @actor.after_notify
      end
    end
  end
end