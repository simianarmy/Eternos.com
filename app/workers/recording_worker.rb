# $Id$
#
# Workling class for analyzing flash files created by flash recorder / red5 server.


class RecordingWorker < Workling::Base
  class ContentCreationException < Exception; end
  
  def analyze(payload)
    logger.debug "RecordingWorker::analyze got payload: #{payload.inspect}"
    return unless @recording = safe_find {
      Recording.find(payload[:id])
    }    
    begin
      logger.debug "Analyzing recording"
      @recording.start_processing!
      
      # Create proper object from recording & metadata
      file_info = RVideo::Inspector.new(:file => @recording.full_filename)
      
      @recording.save_content(file_info) or
        raise ContentCreationException.new('Unexpected error creating content from recording')
      
      @recording.finish_processing!
    rescue Exception => e
      save_error_message(e.message, e.class)
      @recording.processing_error!
    end
  end
  
  private
  
  def save_error_message(message, exception_class='Unknown')
    @recording.update_attributes(:processing_error => "#{exception_class}: #{message}")
    logger.error "Unable to process recording: #{exception_class} - #{message}"
  end
  
end
