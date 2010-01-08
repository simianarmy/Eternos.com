# $Id$

class TwitterActivityStreamItem < ActivityStreamItem
  serialize_with_options do
    methods :source
    except :guid, :attachment_data
  end
  
  # Checks for existing item based on unique criteria.  If not found, calls 
  # base class create method
  def self.sync_from_proxy(p)
    create_from_proxy(p)
  end
  
  def author
    read_attribute(:author) || attachment_data.name
  end
  
  def source
    attachment_data.source
  end
end