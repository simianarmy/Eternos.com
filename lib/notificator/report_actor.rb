module Notificator
  class ReportActor < Actor
    def target= member
      @target = ReportTarget.new(member)
      set_logger_target true
    end

    def notify
      set_logger_target

      
    end
  end
end