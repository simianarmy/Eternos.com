# $Id$
# Module for transcoding videos and other ffmpeg tasks

#require 'rvideo'

class Transcoder 
  @@ToFlashCommand      = "ffmpeg -i $input_file$ -y $resolution$ -ar 44100 -ab 64k -f flv -r 29.97 $output_file$
flvtool2 -U $output_file$"
  
  @@ToThumbnailCommand  = 'ffmpeg -i $input_file$ -y -f mjpeg -t 0.001 -ss 1 -r 1 -vframes 1 -an -s $thumbnail_size$ $output_file$'
  #@@ToAudioCommand      = 'ffmpeg -i $input_file$ -y -acodec copy $output_file$'
  # Anything over 128k can cause errors...
  @@ToAudioCommand      = 'ffmpeg -i $input_file$ -y -f mp3 -ab 128k $output_file$'
  DefaultFlashResolution  = '640x480'
  DefaultThumbnailSize  = '320x240'
  
  attr_reader :command, :executed_commands, :errors
  
  def initialize(source, destination, options={})
    RVideo.logger = options.delete(:logger) || RAILS_DEFAULT_LOGGER
    
    @options = {
      :input_file => source,
      :output_file => destination,
      }.reverse_merge(options)
  end
    
  def source=(file)
    @options[:input_file] = file
  end
  
  def output=(file)
    @options[:output_file] = file
  end
  
  # transcodes source file to flash at destination file, yields processed object.
  # will raise an exception on failure
  def transcodeToFlash
    # Inspect file for properties
    if (file = RVideo::Inspector.new(:file => @options[:input_file])) and file.valid?
      @options[:resolution] = file.resolution
    else
      @options[:resolution] = DefaultFlashResolution
    end
    processed = execute(@@ToFlashCommand, @options)
    block_given? ? yield(processed) : processed
  end
  
  def flashToAudio
    processed = execute(@@ToAudioCommand, @options)
    block_given? ? yield(processed) : processed
  end
  
  def createThumbnail(size=DefaultThumbnailSize)
    @options[:thumbnail_size] = size
    processed = execute(@@ToThumbnailCommand, @options)
    block_given? ? yield(processed) : processed
  end
  
  private 
  
  def execute(command, options)
    RVideo.logger.debug "Executing #{command}..."
    @command = command
    @executed_commands = ''
    @errors = ''
    
    t = RVideo::Transcoder.new
    t.execute(command, options)
    @executed_commands = t.executed_commands.map(&:command).join(',')
    @errors = t.errors.join(',')
    t.processed
  end
end
