# $Id$

module TimelineEvents
  # Allows mix-in parent to use it's acts_as_archivable column as 
  # the start_date value for serialized results
  def start_date
    self.send(self.archivable_attribute)
  end    
end