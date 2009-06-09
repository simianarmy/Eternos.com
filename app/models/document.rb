# $Id$
class Document < Content
  self.content_types     = [] # Catch-all
  self.attachment_fu_options = {}
    
  has_attachment attachment_opts
  validates_as_attachment 
end
