module Notificator
  #base target class
  #indicates target of notification
  class Target
    attr_reader :id

    def initialize id
      @id = id
    end

    def to_s; @id.to_s; end
  end
end