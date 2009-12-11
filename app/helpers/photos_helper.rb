# $Id$

module PhotosHelper
  def photo_link(photo, options={})
    returning String.new do |link|
      link << content_to_s(photo)
      unless options[:thumbnail] == false
        link << content_tag(:br)
        link << if photo.has_thumbnail?
          thumbnail_link(photo)
        else
          photo_image_tag(photo)
        end
      end
    end
  end
  
  def thumbnail_link(photo)
    link_to thumb_image_tag(photo), photo.url,
      :class => "lightview", :title => "#{photo.title}"
  end
  
  private
  
  # Creates custom image tag based on path, instead of default /images dir
  # Takes optional has_thumbnail boolean flag
  
  def photo_image_tag(photo)
    image_tag(photo.url, :class => "photo", :alt => photo.title, 
        :size => photo.image_size)
  end
  
  def thumb_image_tag(photo)
    thumb = photo.thumbnails.first
    image_tag(photo.url(:thumb), :class => "photo", :alt => photo.title, 
        :size => thumb.image_size)
  end
end
