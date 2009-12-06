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

  alias_attribute :album, :collection
  
  serialize_with_options do
    methods :start_date, :url, :thumbnail_url
    only :id, :size, :type, :title, :filename, :width, :height, :taken_at, :content_type, :description
  end
  
  serialize_with_options(:gallery) do
    methods :url, :thumbnail_url
    only :width, :height, :title, :description
  end
  
  
  # Alias start_date to taken_at attribute since we can't override acts_as_archivable in 
  # STI children
  # taken_at can be nil so make sure some date is returned
  def start_date
    taken_at || created_at 
  end
  
  # Use RMagik & EXIF to get date a photo was taken
  after_attachment_saved do |attach|
    if image = Magick::Image.read(attach.full_filename).first
      logger.debug "ImageMagick photo info: #{image.inspect}"
      # the get_exif_by_entry method returns in the format: [["Make", "Canon"]]
      date  = image.get_exif_by_entry('DateTime')[0][1]

      if not date.nil?
        attach.taken_at = DateTime.strptime(date, exif_date_format)
        attach.save!
      end
    end
  end
  
  def thumbnailable?
    true
  end
  
  def rebuild_thumbnails
    # Need original data in new temp file data to re-save
    if data = file_data
      begin
        destroy_thumbnails
      rescue 
        logger.warn "Exception trying to delete thumbnails for photo #{id}: $!"
      end
      # Force re-save of data to kickstart AttachmentFu::process_attachment
      self.temp_data = data
      save
    end
  end
  
end

