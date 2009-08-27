# $Id$

class BackupReportMailer < ActionMailer::Base
  layout 'email'
  
  def daily_storage_report(stats)
    setup
    @recipients  = "reports@eternos.com"
    @subject     = "Daily backup storage stats: #{Date.yesterday} - #{Date.today}"
  
    @stats      = stats
    @stats_keys = stats[:total].keys.reject { |k| k.to_s =~ /_size$/ } - [:backup_items, :s3_cost]
  end
  
  def daily_jobs_report(data)
    setup
    @recipients  = "reports@eternos.com"
    @subject     = "Daily backup jobs data: #{Date.yesterday} - #{Date.today}"
   
    @data         = data
  end
  
  private
  
  def setup
    @from         = "backup-reporter@eternos.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    # For layout template & views
    @image_url    = ActionController::Base.asset_host
    @image_url    = 'http://' + AppConfig.base_domain + '/images' if @image_url.empty?
  end
end
