# $Id$
# ElementService
#
# Helper class for ElementsController to handle multiple decorations

class ElementService
  
  attr_reader :element, :contents
  
  def initialize(element, content)
    @element = element
    @content = content
  end
  
  def save
    return false unless valid?
    begin
      Element.transaction do
        @element.decorations << content
        @element.save!
        true
      end
    rescue
      false
    end
  end
  
  def valid?
    @element.valid? && @content.valid?
  end
end
