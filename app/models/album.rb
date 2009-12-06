class Album < ActiveRecord::Base
  has_many :photos, :as => :collection, :dependent => :destroy
  
  named_scope :by_user, lambda { |user_id|
    { :joins => :photos,
      :conditions => ['contents.user_id = ?', user_id]
    }
  }
  named_scope :include_photos, :include => :photos
end
