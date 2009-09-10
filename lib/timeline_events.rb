# $Id$

module TimelineEvents
  def start_date
    self.send(self.archivable_attribute)
  end
end