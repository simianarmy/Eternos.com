module DashboardHelper
  def table_info_part(title,&content)
    title_tag = content_tag(:h1, title)
    table_tag = content_tag(:table,
               :border => '0',
               :cellpadding => '0',
               :cellspacing => '0',
               :width => '720',
               :class => 'jtable01') do
      yield content
    end
    concat(title_tag + table_tag)
  end

  def td_thead_tag(width, title = '', center = false)
    options = {:class => 'thead', :width => width.to_s}
    options[:align] = 'center' if center
    content_tag(:td, title.empty? ? '&nbsp;' : content_tag(:strong, title), options)
  end

  def td_edit_button(params)
    content_tag(:td, link_to('Edit', params, :class => 'account-edit-button'), :align => 'right')
  end

  def bytes_to_human(orig_size)
    size = orig_size.to_f
    measures = ['B','KB','MB','GB']
    measure = 0
    while (size > 100) && (measure < measures.size - 1)
      measure += 1
      size /= 1024
    end
    ((((size * 10).round % 10).zero? ? "%.0f" : "%.1f") % size) + ' ' + measures[measure]
  end

  def div_flash_notice
    content_tag(:div, '', :class => 'flash_notice', :id => 'notice')
  end

  def personal_form_field(title = '', required = false,&content)
    title = title.empty? ? '&nbsp;' : (title + ':')
    content_tag(:p) do
      result = [content_tag(:label, title), yield(content)]
      result.push ' ' + content_tag(:strong,'*') if required
      concat(result.join)
    end
  end

  def personal_info_part_title(title)
    title_tag = content_tag(:h1, title)
    content_info = content_tag(:p,'Please complete the following personal information. Fields marked with a ' +
            content_tag(:strong,'*') + ' must be filled in.',:class => 'message')
    title_tag + content_info
  end

  def formatted_date_or_na(date, format, na="NA")
    if %W( Date DateTime Time ).include?(date.class.to_s)
      date.strftime(format)
    else
      na
    end
  end
  
  def update_regions_js(value)
    remote_function(
            :update => 'address_region',
            :url => {:action => 'regions'},
            :with => "'c_id='+" + value + "+'&curr=" + @address.region_id.to_s + "'"
    )
  end
end