module Notificator
  class FbPublisher < FbActor

    def notify
      set_logger_target
      
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