# $Id$
class Tag < ActiveRecord::Base  
  # has_many_polymorphs :taggables, 
  #   :from      => [:stories, :contents, :elements, :messages], 
  #   :through   => :taggings,
  #   :dependent => :destroy, :skip_duplicates => false
    
  def find_by_user(user_id)
    [stories.find_by_user_id(user_id),
    contents.find_by_user_id(user_id)].flatten
  end
end
