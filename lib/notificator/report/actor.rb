module Notificator
  module Report
    class Actor < Notificator::Actor
      def target= member
        @target = Report::Target.new(member)
        set_logger_target true
      end

      def notify
        set_logger_target

        dashboard = DashboardPresenter.new(@target.id)
        backup_data = dashboard.backup_data_counts

        # Sending with FB's api
        @logger.info "Sending dashboard news"
        fb_user = Mogli::FbAppUser.new(@target.id.facebook_uid)
        resp = fb_user.dashboard_addNews({
                'news' => [
                        {'message' => "Albums: #{backup_data[:albums]}, Photos: #{backup_data[:photos]}, Videos: #{backup_data[:videos]}, Audio: #{backup_data[:audio]}"},
                        {'message' => "Emails: #{backup_data[:emails]}, Feed Items: #{backup_data[:rss]}, Facebook Items: #{backup_data[:fb]}"},
                        {
                                'message' => "Twitter Items: #{backup_data[:tweets]}, Media Comments: #{backup_data[:media_comments]}, Total: #{backup_data[:total]}",
                                'action_link' => {'text' => 'Check at Eternos.com', 'href' => 'https://eternos.local/dashboard'}
                        }
                ]
        })
        @logger.info "Dashboard news id: " + resp['dashboard_addNews_response']
        # Sending with FB's api

        # OR

        # Sending email stats
        # Sending email stats
      end
    end
  end
end