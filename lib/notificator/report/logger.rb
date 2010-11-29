module Notificator
  module Report
    class Logger < Notificator::Logger
      def before
        puts 'Calculating backups for new user' + (@target.nil? ? '' : (': ' + @target.to_s))
      end

      def after
        puts 'Backups sent to user' + (@target.nil? ? '' : (': ' + @target.to_s))
      end
    end
  end
end