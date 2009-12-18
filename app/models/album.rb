class Album < ActiveRecord::Base
  has_many :photos, :as => :collection, :dependent => :destroy
  
  named_scope :by_user, lambda { |user_id|
    { :joins => :photos,
      :conditions => ['contents.user_id = ?', user_id]
    }
  }
  named_scope :include_photos, :include => :photos
  
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
