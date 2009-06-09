# $Id$

class WysiwygPreview
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  include PhotosHelper
  
  def initialize(html)
    @source = html
  end
  
  def filter
    # Add lightview code to photo thumbnails
    @source.gsub(/<img\s.*id="artifact_photo_(\d+)".*\/>/) do |src|
      # Fetch photo object for fullsize path, do nothing if not found
      if p = Photo.find($1.to_i)
        thumbnail_link(p)
      end
    end
  end
end
    