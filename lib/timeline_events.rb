# $Id$

# Mix-in for AR classes representing Timeline Event Items

module TimelineEvents
  # Allows mix-in parent to use it's acts_as_archivable column as 
  # the start_date value for serialized results
  def start_date
    self.send(self.archivable_attribute)
  end
  
  # end_date value if applicable
  def end_date
    self.end_at if self.respond_to?(:end_at)
  end
end