# $Id$

class EncodingsController < ApplicationController
  
  # controller_method for callback processing
  def callback
    xml = Nokogiri::XML(params['xml'])
    mediaid = xml.xpath('/result/mediaid').text

    Rails.logger.debug "GOT MEDIA ID FROM ENCODING.COM CALLBACK: #{mediaid}"
    # Check the status of the tasks are 'Finished'.
    xml.xpath('/result/format/status').each do |status|
      if status.text == 'Error'
        #Do your error processing
      elsif status.text == 'Finished'
        # do something
      end
    end
    
    render :nothing => true, :status => :ok
  end

end