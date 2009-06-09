# $Id$
# Workling class for transcoding videos to flash
require 'transcoder'

class TranscodeWorker < Workling::Base
  
  def transcode_video(payload)
    return unless source = Content.find(payload[:id])
    @transcoding = Transcoding.create(:parent_id => payload[:id])
    
    begin
      @transcoding.start_transcoding! 
      source_file = source.full_filename
      
      # Get temporary file path for transcoding
      tmpfile = Tempfile.new(File.basename(source_file, File.extname(source_file)) +
        ".flv")
      
      logger.debug "Starting transcoding for #{source_file} to #{tmpfile.path}"
      
      transcoder = Transcoder.new(source_file, tmpfile.path, :logger => logger)
      transcoder.transcodeToFlash do |processed|
        # Save new video attributes
        @transcoding.width = processed.width.to_s
        @transcoding.height = processed.height.to_s
        @transcoding.duration = processed.duration.to_s
        @transcoding.video_codec = processed.video_codec
        @transcoding.audio_codec = processed.audio_codec
        @transcoding.fps = processed.fps rescue nil # fps() sometimes fails
        @transcoding.bitrate = processed.full_bitrate
      end
      
      @transcoding.command = transcoder.command
      @transcoding.command_expanded = transcoder.executed_commands
      @transcoding.size = File.size(tmpfile.path)
      
      # Move new file to same directory as original
      #destination = File.dirname(source_file) + '/' + File.basename(tmpfile.path)
      tmpfile.close
      #FileUtils.cp tmpfile.path, destination
      @transcoding.filename = tmpfile.path
      
      @transcoding.finish_transcoding! # This should kickstart s3 uploading process
      logger.debug "Successfully finished transcoding"
    rescue Exception => e
      logger.error "BARFED in transcoder worker!"
      save_error_message(e.message, e.class)
      @transcoding.transcoding_error!
    ensure
      if transcoder
        @transcoding.command = transcoder.command
        @transcoding.command_expanded = transcoder.executed_commands
      end
    end
    tmpfile.unlink unless tmpfile.nil?
  end
  
  private
  
  def save_error_message(message, exception_class='Unknown')
    @transcoding.update_attributes(:processing_error_message => "#{exception_class}: #{message}")
    logger.error "Unable to transcode file: #{exception_class} - #{message}"
  end
end
