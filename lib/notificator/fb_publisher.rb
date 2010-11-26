module Notificator
  class FbPublisher < Actor

    def target= id
      @target = Mogli::FbAppUser.new(id)
    end

    def notify

      resp = @target.dashboard_addNews({
              'news' => [{
                      'message' => 'You are allowed to use',
                      'action_link' => {
                              'text' => 'Eternos',
                              'href' => 'http://eternos.com'
                      },
              }]
      })

      logger.info 'Message id: ' + resp['dashboard_addNews_response'].inspect
    end
  end
end