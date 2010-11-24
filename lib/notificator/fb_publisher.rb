module Notificator
  class FbPublisher < Actor

    def notify target, logger

      resp = Mogli::FbAppClient.new.old_api('dashboard.addNews', {
              'news' => [{
                      'message' => 'You are allowed to use',
                      'action_link' => {
                              'text' => 'Eternos',
                              'href' => 'http://eternos.com'
                      },
              }],
              'uid' => target.fb_id,
              'image' => 'http://photos-c.ak.fbcdn.net/photos-ak-snc1/v27562/69/82855842117/app_2_82855842117_5081.gif'
      })

      logger.info 'Message id: ' + resp['dashboard_addNews_response'].inspect
    end
  end
end