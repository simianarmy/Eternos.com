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
  
  EncodingStrategy = 'cloud' # or transcode
  
  # Use RVideo to get attributes
  after_attachment_saved do |attach|
    if EncodingStrategy == 'transcode'
      # Don't repeat this if creators have already done this
      unless attach.width
        begin
          if info = RVideo::Inspector.new(:file => attach.full_filename, :ffmpeg_binary => AppConfig.ffmpeg_path)
            attach.save_metadata(info)
          end
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
  
  # Not transcoding videos anymore - using encoding.com instead
  after_create :transcode
  
  # Class methods
  
  # Instance methods
  
  # Disable attachment_fu's process_attachment - not needed.
  # I would think setting :processor => :none would do the trick, but no such luck
  #def process_attachment; end
  
  # adds transcoding job to worker queue
  def transcode
    if EncodingStrategy == 'transcode'
      logger.info "Sending video to transcode worker (#{self.id})"
      # NOTE:
      # At this point attachment_fu has not copied the file to its proper place.
      # The worker may fail if it executes before attachment_fu's callback does...
      # How to chain after_create with after_process_attachment???
      TranscodeWorker.async_transcode_video(:id => self.id)
    end
  end
  
  # Has video been transcoded and uploaded to a streaming server?
  def has_flash?
    not web_video.nil?
  end
    
  def playable?
    true
  end
  
  def encoding_source_url
    S3Buckets::MediaBucket.encoded_url(s3_key)
  end
  
  def encoding_target_url(ext)
    S3Buckets::MediaBucket.encoded_url("#{s3_key}.#{ext}") + '?acl=public-read'
  end
  
  protected
  
  # Hook called by acts_as_saved_to_cloud after upload process completed
  # 
  def uploaded
    Rails.logger.debug "*** post S3 hook called"
    if EncodingStrategy == 'cloud'
      Rails.logger.debug "*** Sending video to encoding.com"
      # Now that video is on cloud server, begin cloud encoding process
      self.encodingid = ENCQ.add_and_process(
        encoding_source_url, #source
        {
          # Task 1: Encode into a 608x size video mp4 (normal)
          # encoding_target_url => EncodingDotCom::Format.create(
          #                'output' => 'mp4',
          #                'size' => '608x0',
          #                'add_meta' => 'yes',
          #                'bitrate' => '1024k',
          #                'framerate' => '25',
          #                'video_codec' => 'libx264',
          #                'audio_bitrate' => '128k',
          #                'profile' => 'baseline',
          #                'two_pass' => 'yes'),
          # Encode into a 608x size video flv w/ vp6
          encoding_target_url('flv') => EncodingDotCom::Format.create(
            'output' => 'flv',
            'size' => '608x0',
            'bitrate' => '1024k',
            'framerate' => '25',
            'video_codec' => 'vp6',
            'audio_bitrate' => '128k'),
          # # Task 2: Encode into a 320x size video (preview)
          #           resource.container_encoded_url('preview') => EncodingDotCom::Format.create(
          #                'output' => 'mp4',
          #                'size' => '320x0',
          #                'add_meta' => 'yes',
          #                'bitrate' => '1024k',
          #                'framerate' => '25',
          #                'video_codec' => 'libx264',
          #                'audio_bitrate' => '128k',
          #                'profile' => 'baseline',
          #                'two_pass' => 'yes'),
                            
            # Task 2: Generate a thumbnail
            encoding_target_url('jpg') => EncodingDotCom::Format.create(
              'output' => 'thumbnail', 
              'width' => '100', 
              'height' => '100',
              'time' => 2),
        },
        #{ 'notify' => encoding_callback_url }
        { 'notify' => encoding_callback_url(:host => 'staging.eternos.com')}
        # Alternatively you could also:
        #{ 'notify' => "marc@eternos.com" }
      )
      save
    end
  end
  
end
