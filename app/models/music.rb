# $Id$
class Music < Audio
  self.content_types = superclass.content_types
  self.attachment_fu_options = superclass.attachment_fu_options
  
  include TimelineEvents
  serialize_with_options do
    methods :url, :duration_to_s
    only :id, :size, :type, :title, :filename, :taken_at, :description, :duration
  end
end
