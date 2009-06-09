# $Id$
class WebVideo < Content
  belongs_to :video, :foreign_key => 'parent_id'
  
  self.content_types    = ['video/flv', 'video/x-flv', 'x-shockwave-flash']
  self.attachment_fu_options = {:content_type => self.content_types,
    :thumbnails => { :preview => "#{Transcoder::DefaultThumbnailSize}",
      :thumb => '100x100' }}
  
  has_attachment attachment_opts
  # Class methods
  
  # Use RVideo to get attributes & thumbnail
  after_attachment_saved do |attach|
    # Don't repeat this if creators have already done this
    unless attach.width
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
      :parent_id => data[:parent_id],
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
  
  # Override base url 
  def url
    #polymorphic_path(self, :format => :flv)
    # for testing, use public link
    public_filename
  end
  
  def preview_url
    thumbnail(:thumb => :preview)
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
end
