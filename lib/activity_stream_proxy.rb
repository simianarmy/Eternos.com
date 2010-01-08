# $Id$

# Proxy classes to normalize activity stream interface methods for passing to activerecord objects.
# Child classes used by ActiveRecord classes to create/update info in a consistent way

# See facebook_activity.rb for usage example

# TODO: use Mash/Hashie?
class ActivityStreamProxy < Hashie::Mash
#  attr_accessor :id, :author, :created, :updated, :message, :source_url, :attribution, :type, :attachment_type
  
  # All this is overkill now that we are using Hashie...
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