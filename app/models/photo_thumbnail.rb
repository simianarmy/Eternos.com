# $Id$
class PhotoThumbnail < ActiveRecord::Base
  belongs_to :photo, :foreign_key => 'parent_id'
  
  has_attachment({
    :content_type => :image, 
    :processor=>'ImageScience'
  }.reverse_merge(Content.attachment_fu_options))
  acts_as_saved_to_cloud
  
  # virtual attributes
  # To disable uploading
  attr_accessor :no_upload
  
  before_destroy :delete_from_cloud
  
  serialize_with_options do
    methods :url
    only :size, :width, :height, :content_type
  end
  
  include CloudStaging
  
  def cdn_url
    S3Buckets::MediaBucket.url(s3_key) if s3_key
  end
  
  def url
    cdn_url || public_filename
  end
  
  # Adds uploader job to queue if file needs to be added to storage
  # because just created or modified.
  def upload
    unless @no_upload
      UploadsWorker.async_upload_content_to_cloud({:id => self.id, :class => self.class.to_s})
    end
  end
  
  # Deletes from s3 before destroy
  def delete_from_cloud
    S3Connection.new(:media).bucket.delete(s3_key) if s3_key
  end
end
