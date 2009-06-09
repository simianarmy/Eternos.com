# $Id$
class Music < Audio
  self.content_types = superclass.content_types
  self.attachment_fu_options = superclass.attachment_fu_options
end
