# $Id$

class EncodingsController < ApplicationController
  
  # controller_method for callback processing
  def callback
    xml = Nokogiri::XML(params['xml']) do |config|
      config.noerror.noblanks
    end
    mediaid = xml.xpath('/result/mediaid').text
    Rails.logger.debug "GOT MEDIA ID FROM ENCODING.COM CALLBACK: #{mediaid}"
    
    if content = Content.find_by_encodingid(mediaid)
      Rails.logger.debug "Matched video #{c.id} type: #{c.type}"
      formats = xml.xpath('//result/format')
      
      # Check the status of the tasks are 'Finished'.
      errors = []
      results = {}
      xml.xpath('/result/format').each do |format|
        status = format.xpath('/status').text
        output = (format.xpath('/output').text == 'flv') ? :video : :thumb
                
        if status == 'Error'
          #Do your error processing
          errors << "Encoding.com error for #{output}"
        elsif status == 'Finished'
          # do something
          results[output] = format.xpath('/destination').text
        end
      end

      if errors.any?
        Rails.logger.warn "Errors from Encoding.com!"
        content.update_attribute(:processing_error_message, errors.join(','))
      else
        # Try to fetch additional information about the video from encoding.com
        begin
          if info = ENCQ.info(mediaid)
            content.duration = info.duration
            content.save(false)
            results[:fps] = info.frame_rate
            results[:bitrate] = info.bitrate
            results[:size] = info.size
            results[:video_codec] = info.video_codec
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