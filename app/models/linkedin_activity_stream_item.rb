# $Id$

class LinkedinActivityStreamItem < ActivityStreamItem
  serialize_with_options do
    methods :source
    except :guid, :attachment_data
  end
  
  def author
    read_attribute(:author) || attachment_data.name
  end
  
  def source
    attachment_data.source
  end
  
  # Collect all text fields for output
  def to_rawtext
    res = []
    res << author
    res << message
    res << tags if !tags.try(:empty?)
    res << comments if !comments.try(:empty?)
    res.join(' ')
  end
  
  protected
  
end