# $Id$

class BackupReportMailer < ActionMailer::Base
  layout 'email'
  include MailHistory
  
  def daily_storage_report(stats)
    setup
    @recipients  = AppConfig.reports_email
    @subject     = "[#{RAILS_ENV}] Daily backup storage stats: #{Date.yesterday} - #{Date.today}"
  
    @stats      = stats
    @stats_keys = stats[:total].keys.reject { |k| k.to_s =~ /_size$/ } - [:backup_items, :s3_cost]
  end
  
  def daily_jobs_report(data)
    setup
    @recipients  = AppConfig.reports_email
    @subject     = "[#{RAILS_ENV}] Daily backup jobs data: #{Date.yesterday} - #{Date.today}"
   
    @data         = data
  end
  
  private
  
  def setup
    @sent_on      = Time.now
    @content_type = "text/html"
  end
end
