# $Id$
class Document < Content
  self.content_types     = [] # Catch-all
  self.attachment_fu_options = {}
    
  has_attachment attachment_opts
  validates_as_attachment 
  
  include TimelineEvents
  serialize_with_options do
    methods :url
    only :size, :type, :title, :filename, :taken_at, :description
  end
end
