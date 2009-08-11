# $Id$

class Photo < Content
  self.content_types   = ['image/gif', 'image/jpeg', 'image/png', 'image/tiff', 
    'image/vnd.microsoft.icon']
  self.attachment_fu_options = {
    :content_type => :image,
    :thumbnails => { :thumb => '100x100>' },
    :processor => 'ImageMagick'}
    
  has_attachment attachment_opts
  validates_as_attachment
 
  @@exif_date_format = '%Y:%m:%d %H:%M:%S'
  cattr_accessor :exif_date_format

  # Use RMagik & EXIF to get date a photo was taken
  after_attachment_saved do |attach|
    photo = Magick::Image.read(attach.full_filename).first
    logger.debug "ImageMagick photo info: #{photo.inspect}"
    # the get_exif_by_entry method returns in the format: [["Make", "Canon"]]
    date  = photo.get_exif_by_entry('DateTime')[0][1]
    
    if not date.nil?
      attach.taken_at = DateTime.strptime(date, exif_date_format)
      attach.save!
    end
  end
  
  def thumbnailable?
    true
  end
  
  # INCOMPLETE: figure out how attachment_fu calls resize_image() 
  # this just creates the thumbnail db record
  def ensure_thumbnail
    if thumbnails.nil? || thumbnails.empty?
      temp_file = temp_path || create_temp_file
      attachment_options[:thumbnails].each { |suffix, size| create_or_update_thumbnail(temp_file, suffix, *size) }
      save_to_storage
    end
  end
  
end

