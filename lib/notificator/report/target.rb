module Notificator
  module Report
    class Target < Notificator::Target

      def to_s
        @id.full_name + ' (' + @id.id.to_s + ')'
      end
    end
  end
end