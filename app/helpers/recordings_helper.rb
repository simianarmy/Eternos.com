module RecordingsHelper
  def show_recording(recording)
    if recording.new_record?
      attach_recording_link('Record something')
    else
      if recording.ready?
        link_to_recording(recording)
      elsif recording.pending?
        content_tag(:div, 'Your recording is being processed', :id => 'flash_notice')
      else
        content_tag(:div, 'There was an error processing your recording', 
          :id => 'flash_error')
      end
    end
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
end
