class Audio < Content
  self.content_types = ['application/ogg', 'audio/mpeg', 'audio/mp3', 'audio-x-ms-wma', 
    'audio/vnd.rn-realaudio', 'audio/x-wav']
  self.attachment_fu_options = {:content_type => self.content_types}
    
  has_attachment attachment_opts
  
  # Use RVideo to get attributes
  after_attachment_saved do |attach|
    # Don't repeat this if creators have already done this
    unless attach.width
      begin
        if info = RVideo::Inspector.new(:file => attach.full_filename)
          attach.save_metadata(info)
        end
      end
    end
  end
  
  # Creates new instance from recording object info
  def self.create_from_recording(data)
    logger.info "Creating new audio from recording: #{data[:filename]}"
    
    returning create(:owner => data[:member],
      :parent_id => data[:parent_id],
      :is_recording => true,
      :size => File.size(data[:filename]),
      :title => "Audio recording: #{File.size(data[:filename])}",
      :filename => File.basename(data[:filename]),
      :content_type => "audio/#{data[:inspector].audio_codec}",
      :temp_path => File.new(data[:filename])
      ) do |audio|
        audio.save_metadata(data[:inspector])
    end
  end
  
  def playable?
    true
  end
  
  def to_s
    (recording? ? 'Audio Recording' : filename) +
      " (#{duration_to_s})"
  end
end
