# $Id$

# Proxy classes to normalize activity stream interface methods for passing to activerecord objects.
# Child classes used by ActiveRecord classes to create/update info in a consistent way

# See facebook_activity.rb for usage example


class ActivityStreamProxy
  attr_accessor :id, :author, :created, :updated, :message, :type, :attachment_type
  
  class Attachment
    attr_reader :data
    
    def initialize(data)
      @data = data
    end
  end
  
  def attachment=(data)
    @attachment = Attachment.new(data)
  end
  
  def attachment_data
    @attachment ? @attachment.data : nil
  end
end