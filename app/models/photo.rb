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
  
  # added to override content's named_scopes that use a different archivable_attribute value
  named_scope :before, lambda {|date|
    { 
      :conditions => ["taken_at <= ?", date] 
    }
  }
  named_scope :after, lambda {|date|
    { 
      :conditions => ["taken_at >= ?", date] 
    }
  }
  # workaround for shitty searchlogic code
  named_scope :not_deleted, :conditions => {:deleted_at => nil}
  
  @@exif_date_format = '%Y:%m:%d %H:%M:%S'
  cattr_accessor :exif_date_format

  alias_attribute :album, :collection
  
  serialize_with_options do
    methods :start_date, :url, :thumbnail_url
    only :id, :size, :type, :title, :filename, :width, :height, :taken_at, :content_type, :description, :collection_id
  end
  
  serialize_with_options(:gallery) do
    methods :url, :thumbnail_url
    only :width, :height, :title, :description
  end
  
  # Use RMagik & EXIF to get date a photo was taken
  after_attachment_saved do |attach|
    unless attach.taken_at # don't do this on every update
      if image = ::Magick::Image.read(attach.full_filename).first
        logger.debug "ImageMagick photo info: #{image.inspect}"
        # the get_exif_by_entry method returns in the format: [["Make", "Canon"]]
        date  = image.get_exif_by_entry('DateTime')[0][1]

        if not date.nil?
          attach.taken_at = DateTime.strptime(date, exif_date_format)
          attach.save!
        end
      end
    end
  end
  
  after_create :update_collection
  
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
  
  protected
  
  # Creates an album for the object if necessary
  def update_collection
    unless collection_id
      # Only create collection if we can access the owner id
      if self.owner
        self.collection = Album.find_or_create_by_name(:name => Date.today.to_s, 
          :user_id => self.owner.id, :cover_id => self.id)
        self.collection.increment! :size
        save(false)
      end
    end
    true
  end
end

