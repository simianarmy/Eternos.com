module Notificator
  class FbPublisher < Actor

    def notify

      resp = Mogli::FbAppClient.new.old_api('dashboard.addNews', {
              'news' => [{
                      'message' => 'You are allowed to use',
                      'action_link' => {
                              'text' => 'Eternos',
                              'href' => 'http://eternos.com'
                      },
              }],
              'uid' => @target.id
      })

      logger.info 'Message id: ' + resp['dashboard_addNews_response'].inspect
    end
  end
end