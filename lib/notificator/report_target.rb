module Notificator
  #base target class
  #indicates target of notification
  class ReportTarget < Target

    def to_s
      @id.full_name + ' (' + @id.id.to_s + ')'
    end
  end
end