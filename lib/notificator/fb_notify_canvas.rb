module Notificator
  class FbNotifyCanvas < Actor

    def target= id
      @target = Mogli::FbAppUser.new(id)
      set_logger_target true
    end
    
    def notify
      set_logger_target
      
      news_id = @target.dashboard_addNews({
              'news' => [{
                      'message' => 'You are allowed to use',
                      'action_link' => {
                              'text' => 'Eternos',
                              'href' => 'http://eternos.com'
                      },
              }]
      })

      logger.info 'Message id: ' + news_id.to_s
    end
  end
end