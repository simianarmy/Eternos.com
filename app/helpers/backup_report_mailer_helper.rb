# $Id$

module BackupReportMailerHelper
  def count_and_size(keys, stats)
    content_tag(:div) do
      html = ''
      keys.each do |k|
        html += content_tag(:p) do
          "#{k.to_s.capitalize} count\t#{stats[k]}<br/>" + 
          "#{k.to_s.capitalize} size\t#{number_to_human_size(stats[k.to_s + '_size'])}"
        end
      end
      html
    end
  end
end
    