class Album < ActiveRecord::Base
  has_many :photos, :as => :collection, :dependent => :destroy
end
