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
        "Backup items count:\t#{stats[:backup_items]}<br/>" + 
        "Backup contents size:\t#{number_to_human_size(stats[:backup_size])}"
      end
    end
  end
end
    