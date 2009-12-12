# $Id$
class Video < Content
  self.content_types    = ['video/mpeg', 'video/mpeg-2', 'video/mp4', 'video/quicktime', 'video/x-ms-wmv', 'video/x-msvideo', 'video/x-sgi-movie', 'video/vdo', 'video/vnd.vivo', 'video/vivo', 'application/x-dvi']
  self.attachment_fu_options = {:content_type => self.content_types}
     
  with_options :foreign_key => 'parent_id' do |m|
    m.has_many :transcodings
    m.has_one :web_video
  end
  
  # Include has_attachment in order to override process_attachment
  has_attachment attachment_opts
  validates_as_attachment
  
  # Use RVideo to get attributes
  after_attachment_saved do |attach|
    # Don't repeat this if creators have already done this
    unless attach.width
      begin
        if info = RVideo::Inspector.new(:file => attach.full_filename)
          attach.save_metadata(info)
        end
      end
    end
    false  # end callback chain
  end
  
  include TimelineEvents
  serialize_with_options do
    methods :url, :thumbnail_url, :thumb_width, :thumb_height,
      :duration_to_s
    only :id, :title, :width, :height, :description, :taken_at
  end
  
  after_create :transcode
  
  # Class methods
  
  # Instance methods
  
  # Disable attachment_fu's process_attachment - not needed.
  # I would think setting :processor => :none would do the trick, but no such luck
  #def process_attachment; end
  
  # adds transcoding job to worker queue
  def transcode
    logger.info "Sending video to transcode worker (#{self.id})"
    # NOTE:
    # At this point attachment_fu has not copied the file to its proper place.
    # The worker may fail if it executes before attachment_fu's callback does...
    # How to chain after_create with after_process_attachment???
    TranscodeWorker.async_transcode_video(:id => self.id)
  end
  
  # Has video been transcoded and uploaded to a streaming server?
  def has_flash?
    not web_video.nil?
  end
    
  def playable?
    true
  end
  
  private
end
