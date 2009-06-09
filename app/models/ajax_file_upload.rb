# $Id$
# Helper class to DRY Attachment_fu + ajax upload controller functionality

class AjaxFileUpload
  class Helper
    include Singleton
    include ActionView::Helpers::AssetTagHelper
  end
  
  # Saves uploaded file, creates thumbnail if applicable, and updates db
  # Returns hash with response status for ajax response
  def self.save(file, options={})
    begin
      if file.save!
        result = upload_success_response(file)
      else
        result = upload_error_response("Error uploading #{file.filename}: #{file.errors.full_messages}")
      end
    rescue Exception => e
      result = upload_error_response("Unexpected Error Uploading #{file.filename}")
      RAILS_DEFAULT_LOGGER.error "Exception saving file from upload: #{e.to_s}"
    end
    result
  end
  
  def self.upload_error_response(message)
    {:status => 'error', :error => message}
  end
  
  def self.upload_success_response(file)
    res = {:status =>'success', :filename => file.filename, :id => file.id}
    if file.has_thumbnail? 
      res[:thumbnail] = file.public_filename(:thumb)
    end
    res
  end
end
