# $Id$

module BackupReportMailerHelper
  def count_and_size(keys, stats)
    content_tag(:div) do
      html = ''
      keys.each do |k|
        html += content_tag(:p) do
          "#{k.to_s.humanize} count:\t#{stats[k]}<br/>" + 
          "#{k.to_s.humanize} size:\t#{number_to_human_size(stats[k.to_s + '_size'])}"
        end
      end
      html
    end
  end
  
  def total_count_and_size(stats)
    content_tag(:div) do
      content_tag(:p) do
        content_tag(:br, "Backup items count:\t#{stats[:backup_items]}") + 
        content_tag(:br, "Backup contents size:\t#{number_to_human_size(stats[:backup_size])}") + 
        content_tag(:br, "S3 contents size:\t#{number_to_human_size(stats[:backup_s3_size])}") +
        content_tag(:br, "S3 Monthly cost:\t#{number_to_currency(stats[:s3_cost])}")
      end
    end
  end
end
    