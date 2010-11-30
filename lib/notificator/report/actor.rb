module Notificator
  module Report
    class Actor < Notificator::Actor
      @period = 'weekly'

      def target= member
        @target = Report::Target.new(member)
        set_logger_target true
      end

      def period= period
        @period = period
      end

      def notify
        set_logger_target

        @logger.info "Updating report date"
        @target.id.last_reported = Time.now
        @target.id.save
#        @target.id.update_attributes(:last_reported => Time.now)

        @logger.info "Calculating stats"
        dashboard = DashboardPresenter.new(@target.id)
        backup_data = dashboard.backup_data_counts

        # Sending with FB's api
        if (!@target.id.facebook_uid.nil?) then
          @logger.info "Sending dashboard news"
          fb_user = Mogli::FbAppUser.new(@target.id.facebook_uid)
          news_id = fb_user.dashboard_addNews({
                  'news' => [
                          {'message' => "Albums: #{backup_data[:albums]}, Photos: #{backup_data[:photos]}, Videos: #{backup_data[:videos]}, Audio: #{backup_data[:audio]}"},
                          {'message' => "Emails: #{backup_data[:emails]}, Feed Items: #{backup_data[:rss]}, Facebook Items: #{backup_data[:fb]}"},
                          {
                                  'message' => "Twitter Items: #{backup_data[:tweets]}, Media Comments: #{backup_data[:media_comments]}, Total: #{backup_data[:total]}",
                                  'action_link' => {'text' => 'Check at Eternos.com', 'href' => 'https://eternos.local/dashboard'}
                          }
                  ]
          })
          @logger.info "Dashboard news id: " + news_id
        end
        # Sending with FB's api

        # OR

        # Sending email stats
        @logger.info "Sending email news"
        #TODO: do not forget remove test from mails
        ActionMailer::Base.delivery_method = :test
        UserMailer.deliver_backup_stats(@target.id, backup_data, @period)
        @logger.info "Email was sent"
        # Sending email stats
      end
    end
  end
end