# $Id$

class EncodingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # controller_method for callback processing
  def callback
    xml = Nokogiri::XML(params['xml']) do |config|
      config.noerror.noblanks
    end
    mediaid = xml.xpath('/result/mediaid').text
    Rails.logger.debug "GOT MEDIA ID FROM ENCODING.COM CALLBACK: #{mediaid}"
    
    if content = Content.find_by_encodingid(mediaid)
      Rails.logger.debug "Matched video #{content.id} type: #{content.type}"
      
      # Check the status of the tasks are 'Finished'.
      errors = []
      results = {}
      xml.css('format').each do |format|
        status = format.css('status').text
        output = (format.css('output').text == 'flv') ? :video : :thumb
        
        Rails.logger.debug "Format: #{output} - Status: #{status}"
        
        if status == 'Error'
          #Do your error processing
          errors << "Encoding.com error for #{output}"
        elsif status == 'Finished'
          # do something
          results[output] = format.css('destination').text
        end
      end
      Rails.logger.debug "Results: #{results.inspect}"
      
      if errors.any?
        Rails.logger.warn "Errors from Encoding.com!"
        content.update_attribute(:processing_error_message, errors.join(','))
      else
        # Try to fetch additional information about the video from encoding.com
        begin
          if info = ENCQ.info(mediaid)
            Rails.logger.debug "Encoding data: #{info.inspect}"
            content.duration = info.duration
            content.save(false)
            
            results[:size] = content.size # Not really but probably close enough
            results[:fps] = info.frame_rate
            results[:bitrate] = info.bitrate
            results[:video_codec] = info.video_codec
            if info.size
              width, height = info.size.split('x')
              results[:width] = width.to_i if width
              results[:height] = height.to_i if height
            end
          end
        end
      
        # Create new object from the video object with additional S3 settings
        WebVideo.create_from_encoding_dot_com(content, results)
      end
    else
      Rails.logger.error "Couldn't lookup content by encodingid: #{mediaid}!"
    end
    
    render :nothing => true, :status => :ok
  end

end