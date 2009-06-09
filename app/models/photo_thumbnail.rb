# $Id$
class PhotoThumbnail < ActiveRecord::Base
  belongs_to :photo, :foreign_key => 'parent_id'
  
  has_attachment({:content_type => :image, 
    :processor=>'Rmagick'}.reverse_merge(Content.attachment_fu_options))
end
