# $Id$

module SlideshowsHelper
  
  def link_to_slideshow(contents, info={})
    unless contents.empty?
      render :partial => 'shared/slideshow', :locals => {:contents => contents, 
        :info=>info}
    end
  end
  
  # Create link with Lightview settings for Lightview slideshow.
  # Some content types like videos require additional div for inline display
  def link_to_slideshow_slide(content, options={})
    # some content types need associated divs in order to be displayed 
    # properly by Lightview.
    if content.playable?
      link_to_playable_slide(content, options)
    else
      link_to_slide(content, content.url, options)
    end
  end
  
  def link_to_playable_slide(content, options)
    options.merge!({
      :duration => content.duration_seconds
    })
    case content
    when WebVideo # Only use flash player if flash format
      capture show_video_link(content, options) do |p|
        link_to_slide(content, "##{dom_id(content)}", options) + p
      end
    when Audio, Music
      capture link_to_audio(content, options.merge(:hidden=>true)) do |p|
        link_to_slide(content, "##{dom_id(content)}", options) + p
      end
    else
      link_to_slide content, content.url, options
    end
  end
  
  def link_to_slide(content, target, options)
    opts = {:id => "slide_#{dom_id(content)}", :rel => options[:set], 
      :title => "#{content.title} :: #{content.description}"}.merge(options)
    if content.width
      opts[:title] += " :: width: #{content.width}, height: #{content.height}" 
      opts[:width] = content.width
      opts[:height] = content.height
    end
    opts[:class] = 'lightview'
    if options[:play_link]
      opts[:class] += ' play_slideshow'
      name = 'Play slideshow'
    else
      name = ''
    end
    
    text = with_options opts do |slide|
      slide.link_to name, target
    end
  end
end