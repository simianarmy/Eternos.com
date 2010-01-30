class Audio < Content
  self.content_types = ['application/ogg', 'audio/mpeg', 'audio/mp3', 'audio-x-ms-wma', 
    'audio/vnd.rn-realaudio', 'audio/x-wav']
  self.attachment_fu_options = {:content_type => self.content_types}
    
  has_attachment attachment_opts
  
  # Use RVideo to get attributes
  after_attachment_saved do |attach|
    # Don't repeat this if creators have already done this
    unless attach.duration
      begin
        if info = RVideo::Inspector.new(:file => attach.full_filename, :ffmpeg_binary => AppConfig.ffmpeg_path)
          attach.save_metadata(info)
        end
      end
    end
  end
  
  include TimelineEvents
  serialize_with_options do
    methods :url, :duration_to_s
    only :id, :size, :type, :title, :filename, :taken_at, :description, :duration
  end
  
  # Creates new instance from recording object info
  def self.create_from_recording(data)
    logger.info "Creating new audio from recording: #{data[:filename]}"
    
    returning create(
      :owner => data[:member],
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
  
  # url to be used by web apps for streaming
  def streaming_url
    audio_url(self, :format => :mp3)
  end
  
  def to_s
    (recording? ? 'Audio Recording' : filename) +
      " (#{duration_to_s})"
  end
end
