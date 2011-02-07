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
        obj.screencap_url, :class => 'lightview', :rel => 'iframe'
      end
    when Album, BackupPhotoAlbum
      if obj.cover_photo
        link_to_lightview image_tag(obj.cover_photo.thumbnail_url), image_gallery_path(:album_id => obj.id), 
          {}, {:rel => "'iframe'"}, {:autosize => false, :height => '800', :width => '800'}
      end
    end  

    img || '&nbsp;'
  end

  def search_icon(obj)
    icon = case obj
    when FacebookActivityStreamItem, Comment
      'fb.png'
    when TwitterActivityStreamItem
      'twitter.png'
    when Feed, FeedEntry
      'rss.png'
    when Content
      obj.content_icon
    when BackupEmail
      'email_accept.png'
    else
      content_icon_path + obj.to_str + '.png'
    end
    
    icon || 'BROKEN'
  end
  
  def search_title_text(obj)
    if obj.respond_to?(:title) && !obj.title.blank?
      obj_text_helper(obj, :title)
    elsif obj.respond_to?(:name) && !obj.name.blank?
      obj_text_helper(obj, :name)
    else
      obj.to_str.humanize.singularize    
    end
  end
  
  def search_title(obj)
    search_details_link(search_title_text(obj), obj)
  end
  
  def search_summary(obj)
    Rails.logger.debug "summary for search object #{obj.inspect}"
    case obj
    when Feed
      obj_text_helper(obj, :title)
    when FeedEntry
      obj_text_helper(obj, :preview)
    when Content
      obj_text_helper(obj, :description)
    when ActivityStreamItem
      obj_text_helper(obj, :message)
    when Comment
      obj_text_helper(obj, :comment)
    end
  end
  
  def search_date(obj)
    if obj.respond_to?(:start_date) && obj.start_date
      obj.start_date.strftime("%c")
    elsif obj.respond_to?(:created_at) && obj.created_at
      obj.created_at.strftime("%c")
    else
      ""
    end
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
  
  protected
  
  # Allows callers to send both regular objects and ThinkingSphinx search result objects
  # that don't have the excerpts method
  def obj_text_helper(obj, txt_attribute)
    obj.excerpts.nil? ? obj.send(txt_attribute) : obj.excerpts.send(txt_attribute)
  end
end
      
  