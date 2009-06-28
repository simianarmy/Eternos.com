class ContactEmail < ActiveRecord::Base
  belongs_to :profile
  
  validates_uniqueness_of :email, :scope => :profile_id
end