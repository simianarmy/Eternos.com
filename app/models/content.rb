# $Id$

class Content < ActiveRecord::Base
  has_many :decorations, :dependent => :destroy
  has_many :elements, :through => :decorations
  belongs_to :owner, :class_name => 'Member', :foreign_key => 'user_id'
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :collection, :polymorphic => true
  
  class UnknownContentTypeException < Exception; end
  
  class << self
    attr_accessor :content_types, :attachment_fu_options, :types
    def attachment_opts
      self.attachment_fu_options.reverse_merge(Content.attachment_fu_options)
    end
  end
  
  self.types         = ['Video', 'Photo', 'Music', 'Document', 'WebVideo']
  self.attachment_fu_options = {
    :storage => :file_system, 
    :path_prefix => "public/assets",
    :max_size => 50.gigabytes,
    :thumbnail_class => 'PhotoThumbnail',
    :processor => :none}
  
  has_attachment attachment_opts
  acts_as_saved_to_cloud
  acts_as_commentable
  acts_as_restricted :owner_method => :owner
  acts_as_archivable :on => :created_at
  acts_as_time_locked
  acts_as_taggable_on :tags
  acts_as_av_attachable
  
  validates_presence_of :title, :message => "Please Enter a Title"
  
  serialize_with_options do
    methods :url, :thumbnail_url
    only :size, :type, :title, :filename, :width, :height, :taken_at, :description
  end
  
  # Virtual attributes
  # Disable cloud upload on create
  attr_writer :no_upload
  
  # Define start_date for serializing.  Define in child classes if start_date
  # should return a different column value than the ones shown
  def start_date
    taken_at || created_at 
  end
  
  before_create :set_title
  # TODO: Make this work w/ attachment_fu
  before_create :set_content_type_by_content
  before_destroy :delete_from_cloud
  
  include CommonDateScopes
  named_scope :recordings, :conditions => {:is_recording => true}
  named_scope :photos, :conditions => {:type => 'Photo'}
  named_scope :web_videos, :conditions => {:type => 'WebVideo'}
  named_scope :audio, :conditions => {:type => 'Audio'}
  named_scope :music, :conditions => {:type => 'Music'}
  named_scope :all_audio, :conditions => {:type => ['Audio', 'Music']}
  named_scope :all_video, :conditions => {:type => ['Video', 'WebVideo']}
  named_scope :media, :conditions => {:type => ['WebVideo', 'Audio', 'Music']}
  #  :include => :thumbnails
  named_scope :collections, :group => 'collection_id', :include => :collection
  named_scope :photo_albums, :group => 'collection_id', 
    :conditions => {:collection_type => ['BackupPhotoAlbum', 'Album']}
  named_scope :albums_with_photos, :group => 'collection_id', 
      :conditions => {:collection_type => ['BackupPhotoAlbum', 'Album']},
      :include => {:collection => :content_photos}

  # thinking_sphinx
  define_index do
    # fields
    indexes title
    indexes filename
    indexes description
    indexes tags(:name), :as => :tags
    indexes comments.title, :as => 'comment_title'
    indexes comments.comment, :as => :comment
    
    # attributes
    has user_id, created_at, updated_at, taken_at, :size, :type, duration
    
    where "deleted_at IS NULL"
    group_by "user_id"
  end
  
  sphinx_scope(:by_user) { |user_id|
    {:with => {:user_id => user_id}}
  }
  
  # Class methods
  
  # Class factory
  # Creates & returns subclass based on passed type
  
  def self.factory(options={})
    if options[:content_type]
      type = class_from_content_type(options[:content_type])
    else
      type = class_from_content_type(content_type = detect_mimetype(options[:uploaded_data]))
      options[:content_type] = content_type
    end
  
    begin
      type.constantize.new(options)
    rescue
      raise UnknownContentTypeException, "Unknown content type!"
    end
  end

  def detect_mimetype(data)
    self.class.detect_mimetype(data)
  end
  
  # From mime-types gem - added as class methods here as helper 
  # for class factory
  def self.detect_mimetype(data_or_filename)
    return MIME::InvalidContentType unless data_or_filename
    f = data_or_filename.respond_to?(:original_filename) ? data_or_filename.original_filename : data_or_filename
    types = MIME::Types.type_for(f)
    types.any? ? types.first.content_type : MIME::InvalidContentType
  end
  
  # Returns proper class type based on content_type
  # Defaults to Document if no matches
  def self.class_from_content_type(content_type='')
    types.detect {|t| t.constantize.content_types.include?(content_type) } || 'Document'
  end
  
  # Instance methods
  
  def validate
    errors.add(:member, "You must be logged in") unless owner
  end
  
  def to_s
    "#{filename} (#{help.number_to_human_size(size)})"
  end
    
  def recording?
    read_attribute(:is_recording) == true
  end
  
  # Takes RVideo::Inspector or Transcoder object
  def save_metadata(info)
    logger.debug "Saving content metadata"
    # Inspector borks on some methods sometimes...damned if I know why
    fps = info.fps rescue nil
    bitrate = (info.respond_to?(:full_bitrate) ? info.full_bitrate : info.bitrate.to_s) rescue nil
    
    update_attributes :width => info.width,
      :height => info.height,
      :duration => info.duration.to_s,
      :bitrate => bitrate,
      :fps => fps
  end
  
  # Called by acts_as_saved_to_cloud when state enters :complete
  # Adds uploader job to queue if file needs to be added to storage
  # because just created or modified.
  def upload
    unless @no_upload
      UploadsWorker.async_upload_content_to_cloud(:id => self.id, :class => "Content")
      logger.debug "Upload worker job sent for content #{self.id}"
      puts "Upload worker job sent for content #{self.id}"
    end
  end
  
  # Override in subclasses that can be played like audio & video
  def playable?
    false
  end
  
  # Override in subclasses that can be thumbnailed
  def thumbnailable?
    false
  end
  
  def has_thumbnail?
    thumbnails.any?
  end
  
  def thumbnail
    thumbnails.first
  end
  
  def cdn_url_with_protocol
    'http:' + cdn_url
  end
  
  def cdn_url
    S3Buckets::MediaBucket.url(s3_key) if s3_key
  end
  
  def thumbnail_url(tp=:thumb)
    thumbnail.url rescue thumbnail_path(:thumb => tp)
  end
  
  # Returns path to thumbnail if one exists, or generic icon for the type
  def thumbnail_path(options={})
    thumb = options[:thumb] || :thumb
    if has_thumbnail?
      public_filename(thumb)
    elsif !options[:no_default]
      content_icon
    end
  end

  # Returns absolute URL to content
  def absolute_url(request)
    cdn_url || (request.protocol + request.host_with_port + public_filename)
  end
  
  def url
    cdn_url or public_filename
  end
  
  # Url to preview image
  # Override in child classes if preview thumbnails exist
  def preview_url
    url
  end
    
  def dated
    taken_at ? taken_at : created_at
  end
  
  def duration_to_s
    d = duration_seconds
    [d/3600, d/60 % 60, d % 60].map{|t| t.to_s.rjust(2, '0')}.join(':')
  end
  
  def duration_seconds
    duration ? (duration.to_i) / 1000 : 0
  end
  
  def duration_seconds_float
    duration ? (duration.to_f) / 1000 : 0
  end
  
  def content_icon_path
    "/javascripts/timeline/icons/"
  end
  
  # Returns image filename for content type
  def content_icon
    content_icon_path << case self
    when Audio
      "audio.png"
    when Music
      "music.png"
    when Photo
      "photo.png"
    when Video, WebVideo
      "movie.png"
    else
      'doc.png'
    end
  end
  
  def file_data
    begin
      @data = if s3_key
        S3Downloader.new(:media).fetch_value(s3_key)
      elsif File.exist? full_filename
        IO.read full_filename
      end
    end
    @data
  end
  
  protected
  
  # Deletes from s3 before destroy
  def delete_from_cloud
    S3Connection.new(:media).bucket.delete(s3_key) if s3_key
  end
  
  def uploaded
    logger.debug "Content object: #{self.id} saved to cloud !"
  end
  
  # before_create callback
  def set_title
    if filename && (title.blank? || (title == "Document"))
      self.title = File.basename(filename, File.extname(filename)).titleize
    end
    true
  end
  
  # before_create callback described @ 
  # http://www.rorsecurity.info/journal/2009/2/27/mime-sniffing-countermeasures.html
  # to ensure proper mime-type extension is used for filename
  # Modified by me to actually work :)
  
  def set_content_type_by_content
    check_file = self.full_filename || self.temp_path
    if File.exists? check_file
      mime = MIME.check_magics(check_file) #try magic numbers first
      mime ||= MIME.check(check_file) if self.content_type.nil? #do other checks if it failed
    
      if mime
        self.content_type = mime.to_s
        self.filename += mime.typical_file_extension unless mime.match_filename?(self.filename)
      end
    end
    true
  end
  
  
end
