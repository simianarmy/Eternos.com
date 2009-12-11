# $Id$
module ContentHelper
  # Helper for Flash+javascript file upload form urls
  def create_content_path_with_session_information
    session_key = ActionController::Base.session_options[:key]
    contents_path(session_key => cookies[session_key], request_forgery_protection_token => form_authenticity_token)
  end
  
  def content_to_s(object)
    "#{object.filename} (#{number_to_human_size(object.size)})"
  end
  
  # links to content object, using thumbnail image if available
  # unless thumbnail option explicitly turned off with :thumbnail => false
  
  def link_to_content(object, options={})
    case object
    when Photo
      photo_link(object, options)
    when Audio, Music
      link_to_audio(object, options)
    when Video, WebVideo
      link_to_video(object, options)
    when Recording
      link_to_video(object.content, options)
    else
      link_to object.title, polymorphic_path(object)
    end
  end
     
  def link_to_audio(object, options={})
    render :partial => 'shared/audio_link', :locals => {:audio => object, :options => options}
  end 
  
  # Helpers for different content-types - could be cleaned up
  def link_to_video(video, options={})
    if options[:thumbnail] == false
      show_video_link(video, options)
    elsif video.kind_of? WebVideo
      show_video_player(video, options)
    elsif video.has_flash?
      show_video_player(video.web_video, options)
    else
      show_video_link(video, options)
    end
  end
  
  def show_video_link(video, options={})
    # Link to lightview that plays flash video
    if video.kind_of? WebVideo
      capture(show_video_player(video, :hidden => true, :autoPlay => true, :filename => false)) do |flash|
        link_to(options[:title] || video.to_s, "##{dom_id(video)}", :class => 'lightview', :rel => 'inline',
          :title => "#{video.title} :: #{video.description}") + flash
      end
    else
      # Link to lightview that plays embedded video
      render :partial => 'shared/video_link', :locals => {:video => video, :options => options}
    end
  end
  
  def show_video_player(video, options={})
    render :partial => 'shared/flash_video_player', :object => video, 
      :locals => {:options => options}
  end
        
  def video_player_swf_url
    '/swf/flowplayer.commercial-3.1.5.swf'
  end
    
  def content_date_select(content)
    calendar_date_select :content, :taken_at,
    	:after_close => remote_function(
    	  :url => content_path(content),
        :method => :put,
        :with => "'content[taken_at]='+escape($('content_taken_at').value)")
  end
  
  # General purpose view helper for content lists.  Takes thumbnail and link options (required)
  # to determine output style
  def content_list_tile(item, options={})
    t = ''
    t = image_tag(options[:thumbnail], :class=>"alignleft")  if options[:thumbnail] 
    t << options[:link]
    t
  end
     
  def tooltip_for_content(item)
    tooltip = item.title
    tooltip << content_tag(:br)
    tooltip << image_tag(item.thumbnail) if item.has_thumbnail?
    tooltip << content_tag(:br)

    if item.playable?
      tooltip << 'Click to play'
    elsif !item.has_thumbnail?
      tooltip << 'No preview available'
    end
    tooltip
  end
  
  def tags_field_description
    #tag('br') + content_tag(:span, t('form.input.tags.description'), :class => 'fine-print')
  end
  
end
