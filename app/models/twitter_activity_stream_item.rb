# $Id$

class TwitterActivityStreamItem < ActivityStreamItem
  serialize_with_options do
    methods :start_date
    except :guid, :attachment_data
  end
end