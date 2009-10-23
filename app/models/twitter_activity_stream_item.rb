# $Id$

class TwitterActivityStreamItem < ActivityStreamItem
  serialize_with_options do
    methods :start_date, :source
    except :guid, :attachment_data
  end
  
  def author
    read_attribute(:author) || attachment_data.name
  end
  
  def source
    attachment_data.source
  end
end