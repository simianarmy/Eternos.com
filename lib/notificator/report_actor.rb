module Notificator
  class ReportActor < Actor
    def target= member
      @target = ReportTarget.new(member)
    end

    def notify
      set_logger_target

      
    end
  end
end