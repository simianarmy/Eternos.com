# $Id$
class WebVideo < Content
  belongs_to :video, :foreign_key => 'parent_id'
  
  self.content_types    = ['video/flv', 'video/x-flv', 'x-shockwave-flash']
  self.attachment_fu_options = {:content_type => self.content_types,
    :thumbnails => { :preview => "#{Transcoder::DefaultThumbnailSize}",
      :thumb => '100x100' }}
  
  has_attachment attachment_opts
  # Class methods
  
  include TimelineEvents
  serialize_with_options do
    methods :url, :thumbnail_url, :thumb_width, :thumb_height,
      :duration_to_s
    only :id, :title, :width, :height, :description, :taken_at
  end
  
  # Use RVideo to get attributes & thumbnail
  after_attachment_saved do |attach|
    # Don't repeat this if creators have already done this
    unless attach.width || attach.bitrate
      begin
        if info = RVideo::Inspector.new(:file => attach.full_filename)
          attach.save_metadata(info)
        end
      end
    end
    attach.create_thumbnails if attach.thumbnails.empty?
  end
  
  # Creates new instance from transcoding object info
  def self.create_from_transcoding(transcoding)
    logger.info "Creating new web video from transcoding: #{transcoding.inspect}"
    
    returning create(
      :parent_id => transcoding.parent_id, 
      :size => transcoding.size, 
      :title => File.basename(transcoding.filename),
      :filename => File.basename(transcoding.filename),
      :content_type => transcoding.content_type,
      :temp_path => File.new(transcoding.filename)
      ) do |video|
        video.save_metadata(transcoding)
    end
  end
  
  # Create new instance from recording info
  def self.create_from_recording(data)
    logger.info "Creating new web video from recording: #{data.inspect}"
    info = data[:inspector]
    
    returning create(
      :owner => data[:member],
      :is_recording => true,
      :title => "Video recording: #{File.basename(data[:filename])}",
      :filename => File.basename(data[:filename]),
      :taken_at => Time.now,
      :content_type => "video/#{info.video_codec}",
      :temp_path => File.new(data[:filename])
      ) do |video|
        video.save_metadata(info)
    end
  end
  
  # Create new instance from video record info
  def self.create_from_encoding_dot_com(video, info={})
    logger.debug "Creating new web video from video: #{video.inspect}"
    
    if info[:video] =~ /http:.+s3\.amazonaws\.com\/(.+)\?acl=.+$/
      info[:s3_key] = $1
    end
    unless info[:s3_key]
      logger.error "Can't create encoding.com video without destination S3 URL!"
    end
    
    vid = self.create(
      :owner => video.member,
      :s3_key => info[:s3_key],
      :title => video.title,
      :filename => video.filename,
      :taken_at => video.taken_at,
      :bitrate => info[:bitrate],
      :content_type => info[:video_codec],
      :size => info[:size],
      :duration => video.duration,
      :fps => info[:fps],
      :parent => video
      ) do |video|
        video.no_upload = true # Prevent cloud upload!
        
        # Save S3 thumbnail path
        if info[:thumb] =~ /http:.+s3\.amazonaws\.com\/(.+)\?acl=.+$/
          thumb = video.thumbnails.new(:width => 100, :height => 100, 
            :state => 'complete',
            :filename => File.basename($1),
            :s3_key => $1)
          thumb.no_upload = true
          thumb.save(false)
        end
    end # create
    # HACK HACK
    # Force cloud status to uploaded
    vid.update_attribute(:state, 'complete')
  end
  
  # Creates thumbnail from 1st frames of video
  def create_thumbnails
    WebVideo.attachment_fu_options[:thumbnails].each do |thumb_name, size|
      logger.debug("Creating thumbnail #{thumb_name} with dimensions #{size}")
      begin
        Tempfile.open(filename) do |temp|
          Transcoder.new(full_filename, temp.path).createThumbnail(size) do |inspector|
            # From attachment_fu's create_or_update_thumbnail
            returning find_or_initialize_thumbnail(thumb_name) do |thumb|
              width, height = size.split('x')
              thumb.attributes = {
                :content_type             => 'image/jpeg',
                :filename                 => File.basename(thumbnail_name_for(thumb_name), 
                  File.extname(filename)) + File.extname(temp.path),
                :temp_path                => temp.path,
                :width                    => width,
                :height                   => height
              }
              thumb.save!
            end
          end
          # Not sure why attachment_fu doesn't do this...
          FileUtils.mv temp.path, full_filename(thumb_name)
        end
      rescue
        logger.warn("Error saving thumbnail: " + $!)
      end
    end
  end
  
  def preview_url
    thumb(:preview).try(:url)
  end
  
  def thumbnail_url
    thumb(:thumb).try(:url)
  end
  
  def thumb_width(type=:thumb)
    thumb(type).try(:width)
  end
  
  def thumb_height(type=:thumb)
    thumb(type).try(:height)
  end
  
  def playable?
    true
  end
  
  def to_s
    (recording? ? 'Video Recording' : filename) +
      " (#{help.number_to_human_size(size)})"
  end
  
  private
  # Override attachment_fu
  def destroy_thumbnails
    thumbnail_class.find_all_by_parent_id(self.id).map { |thumb| thumb.destroy }
  end
  
  def thumb(type)
    thumbnails.find_by_thumbnail(type)
  end
end
