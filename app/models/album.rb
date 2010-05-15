class Album < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Member', :foreign_key => 'user_id'
  has_many :photos, :as => :collection, :dependent => :destroy
  
  named_scope :include_photos, :include => :photos
  
  acts_as_restricted :owner_method => :owner
  acts_as_archivable :on => :created_at
  acts_as_time_locked
  acts_as_taggable
  acts_as_commentable
  
  serialize_with_options(:gallery) do
    methods :cover_photo_url
    except :id, :cover_id
    # Because serialize_with_options only supports 1 level of nesting, we have 
    # to specify the attributes to exclude manually in the include hash - booo
    includes :photos => { 
        :methods => [:url, :thumbnail],
        :except => [:id, :size, :type, :filename, :thumbnail, :bitrate, :created_at, 
          :updated_at, :user_id, :content_type, :duration, :version, :processing_error_message,
          :fps, :state, :is_recording, :s3_key] 
      }
  end
  
  alias_attribute :num_items, :size
  alias_attribute :start_date, :created_at
  
  # Returns content Photo object for the album cover
  def cover_photo
    # Try to avoid using invalid photos if there are multiple backup photos with the 
    # same source photo id
    photos.first
  end
  
  def cover_photo_url
    cover_photo.url rescue nil
  end
  
end
