# $Id$
#
# Class for recorded audio or video object

class Recording < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :content, :dependent => :destroy
  
  validates_presence_of :filename, :message => "Error creating file"
  #validates_uniqueness_of :filename, :message => "Filename is in use"
  
  acts_as_state_machine :initial => :pending
  
  state :pending
  state :processing
  state :complete, :enter => :cleanup
  state :error
  
  class AudioConversionException < Exception; end
  class ContentCreationException < Exception; end
  
  # On successful create, initiate processing job
  event :start_processing do
    transitions :from => :pending, :to => :processing
  end
  
  event :finish_processing do
    transitions :from => :processing, :to => :complete
  end
  
  event :processing_error do
    transitions :from => :processing, :to => :error
  end
  
  # Helpers to determine content type of recording
  def audio?
    filename =~ /^audio/
  end
  
  def video?
    filename =~ /^video/
  end
  
  def ready?
    return false if state.nil?
    complete? && content
  end
  
  def to_s
    (audio? ? 'Audio' : 'Video') + " recording: #{filename}"
  end
  
  def save_content(inspector)
    source_info do |info, klass|
      info[:inspector] = inspector
      klass.create_from_recording(info) or 
        raise ContentCreationException.new('Unable to create #{content.class} object')
      self.content = klass
      save!
    end
  end
    
  # Adds analyze job to queue
  def analyze
    logger.info "sending recording to worker"
    RecordingWorker.async_analyze(:id => self.id)
  end
  
  # Delete original flash file from disk once successfully processed.
  def cleanup
    begin
      File.delete(full_filename, full_filename + ".meta")
    rescue
      logger.warn "Unable to delete recordings files: #{full_filename}*"
    end
  end
  
  # Returns filename with full path
  def full_filename
    filename ? File.join( AppConfig.FlashRecordingPath, filename) : ""
  end
  
  # Converts flash audio recording to mp3, returns path to destination
  def to_mp3
    temp = Tempfile.new(File.basename(filename, '.flv') + ".mp3")
    
    begin
      transcoder = Transcoder.new(full_filename, temp.path)
      transcoder.flashToAudio
      save_transcoder_commands(transcoder)
    rescue RVideo::TranscoderError => e
      save_transcoder_commands(transcoder)
      raise AudioConversionException.new("Unable to convert recording to audio: #{e.message}")
    end
    
    temp.path
  end
    
  protected
  
  def validate_on_create
    logger.debug("Validating existence of recording file: #{full_filename}")
    errors.add('filename', 'Invalid file') unless File.exists?(full_filename) && File.size?(full_filename)
  end
  
  private
  
  def save_transcoder_commands(transcoder)
    self.update_attributes(:command => transcoder.command,
      :command_expanded => transcoder.executed_commands)
    end
    
  # Create info hash for passing to content creation methods
  def source_info
    source_file = audio? ? to_mp3 : full_filename
    info = {:member => member, :filename => source_file}
    info[:parent_id] = self.id
    yield info, (audio? ? Audio : WebVideo)
  end
end