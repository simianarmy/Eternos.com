module RecordingsHelper
  # Displays link to av recording, with optional thumbnail & title
  def link_to_recording(recording, options={})
    case rec = recording.content
    when WebVideo
      link_to_video(rec, options)
    when Audio
      link_to_audio(rec, options)
    else
      link_to(options[:title] || recording.filename, '#video_player', :class => 'popup_get')
    end
  end
  
  # For recording create/view forms
  def show_recording(recording)
    if recording.new_record?
      attach_recording_link('Record Message')
    else
      if recording.ready?
        link_to_recording(recording)
      elsif recording.error?
        content_tag(:div, 'There was an error processing your recording', :id => 'flash_error') +
        content_tag(:div, recording.processing_error, :id => 'flash_error')  
      else
        content_tag(:div, :id => 'flash_notice') do |div|
          'Your recording is being processed.'
#          link_to_recording(recording, :thumbnail => false, :title => "Preview")
        end
      end
    end
  end
  
  # Creates link to lightview popup for recorder flash app
  # Takes optional describable object id
  # => ie. photo id, description id
  def link_to_recorder(describable_object_id=0)
    link_to_lightview 'Record spoken or video description',  
      "/swf/Recorder.swf?userid=#{current_user.id}", {
          :class => 'recording_popup_link', 
          :onclick => "create_cookie('#{RECORDING_CONTENT_PARENT_COOKIE}', 
            '#{describable_object_id}')"
          },
        {:title => "'Record spoken description'", :rel => "'flash'"}, 
        {:width => 380, :height => 297, 
          :flashvars => "'movie=Recorder.swf?userid=#{current_user.id}&quality=high'"}
  end
  
  def attach_recording_link(title, options={})
    link_to_remote title, {:update => options[:div], 
      :url => new_recording_path(:attach_to => options[:parent]), 
      :loading => "if ($('recording')) { $('recording').hide(); } $('#{options[:div]}').hide();", 
      :complete => visual_effect(:toggle_slide, options[:div], :duration => 0.5)}
  end
  
  def detach_recording_link(recording, options={})
    link_to_remote 'Delete', {
      :url => recording_url(recording, :parent => options[:parent]), :method => :delete,
      :loading => "load_busy($('recording'))",
      :complete => "unload_busy(); $('recording').fade();"}
  end
  
  def recording_popup_link(title)
    link_to title, new_recording_path(:dialog => true), :class => 'lightview', :rel => 'iframe',
      :title => ':: Create Recording :: width: 660, height: 700'
  end
end
