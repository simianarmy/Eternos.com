# $Id$

# Downloads images from network sources

#require 'workling_helper'
require 'benchmark'
class ImageDownloadWorker < Workling::Base
  include WorklingHelper
  
  def download_image(payload)
    logit 'ImageDownloadWorker', "#{self.class.to_s} got payload #{payload.inspect}"
    return unless bp = safe_find {
      BackupPhoto.find(payload[:id])
    }
    begin
      BackupPhotoDownloader.download_photo(bp)
    rescue
      bp.download_error!
      logit 'ImageDownloadWorker', "Exception in #{self.class.to_s}: " + $!
    end
  end
end
