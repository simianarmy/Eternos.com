# $Id$

# STI child of ActivityStreamItem for Facebook stream items
# See ActivityStreamProxy class for item attributes

class FacebookActivityStreamItem < ActivityStreamItem
  # Creates object from a ActivityStreamProxy instance
  def self.create_from_proxy(stream_id, item)
    create(:activity_stream_id => stream_id,
      :created_at => item.created,
      :updated_at => item.updated,
      :published_on => Time.at(item.created),
      :message => item.message,
      :activity_type => item.type,
      :attachment_data => item.attachment_data,
      :attachment_type => item.attachment_type)
  end
end
