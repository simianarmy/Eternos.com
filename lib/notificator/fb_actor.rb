module Notificator
  class FbActor < Actor

    def target= id
      @target = Mogli::FbAppUser.new(id)
    end
  end
end