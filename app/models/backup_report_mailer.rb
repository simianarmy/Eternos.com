# $Id$

class BackupReportMailer < ActionMailer::Base
  def daily_storage_report(stats)
    @recipients  = "reports@eternos.com"
    @from        = "mailer@eternos.com"
    @subject     = "Daily backup storage stats: #{Date.yesterday} - #{Date.today}"
    @sent_on     = Time.now
    @content_type = "text/html"
    
    @stats      = stats
    @stats_keys = stats[:total].keys.reject { |k| k.to_s =~ /_size$/ } - [:backup_items]
  end
end
