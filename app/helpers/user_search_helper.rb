# $Id$

# Helper methods for search results 

module UserSearchHelper
  def search_thumbnail(obj)
    img = case obj
      # videos don't get clickable video - just thumb for now
    when WebVideo
      image_tag(obj.thumbnail_url, :width => 100, :height => 100) if obj.thumbnail_url
    when Content
      link_to_content(obj, :thumbnail_only => true, :thumbnail_width => 100, :thumbnail_height => 100)
    when FeedEntry
      if obj.respond_to?(:screencap_url) && obj.screencap_thumb_url
        link_to image_tag(obj.screencap_thumb_url, :width => 100, :height => 100), 
        obj.screencap_url, :class => 'lightview'
      end
    end  

    img || '&nbsp;'
  end

  def search_icon(obj)
    icon = case obj
    when FacebookActivityStreamItem
      'fb.png'
    when TwitterActivityStreamItem
      'twitter.png'
    when Feed, FeedEntry
      'rss.png'
    when Content
      obj.content_icon
    when BackupEmail
      'email_accept.png'
    end
    
    icon || 'BROKEN'
  end
  
  def search_title(obj)
    title = if obj.respond_to?(:title) && !obj.title.blank?
      obj.excerpts.title
    elsif obj.respond_to?(:name) && !obj.name.blank?
      obj.excerpts.name
    else
      obj.to_str.humanize.singularize    
    end
    search_details_link(title, obj)
  end
  
  def search_summary(obj)
    case obj
    when Feed
      obj.excerpts.title
    when FeedEntry
      obj.excerpts.preview
    when Content
      obj.excerpts.description
    when ActivityStreamItem
      obj.excerpts.message
    end
  end
  
  def search_date(obj)
    obj.start_date.to_s(:long)
  end
  
  def search_link(obj)
    case obj
    when Feed, FeedEntry
      link_to obj.url, obj.url, :target => '_new'
    else
      #search_details_link('Details', obj)
    end
  end
  
  def search_tags(obj)
    obj.tag_list.map{|t| "##{t} "}.to_s if obj.respond_to?(:tags)
  end
  
  def search_details_link(name, obj)
    spinner_dom = dom_id(obj, 'result-main')
    link_to_remote name, :url => item_details_path(:id => current_user.id, :type => obj.class.to_s, 
      :events => obj.id), :target => '_new', :update => dom_id(obj, 'full_view'), 
      :loading => "spinner.load('#{spinner_dom}')", 
      :complete => "spinner.unload()"
  end
end
      
  