# $Id$
class Transcoding < ActiveRecord::Base
  belongs_to :video, :foreign_key => 'parent_id'
  
  validates_presence_of :parent_id
  
  acts_as_state_machine :initial => :raw
  state :raw  # Initial state, unprocessed
  state :transcoding
  state :processed, :enter => Proc.new {|o| WebVideo.create_from_transcoding(o)}
  state :error
  
  event :start_transcoding do
    transitions :from => :raw, :to => :transcoding
  end
  
  event :finish_transcoding do
    transitions :from => :transcoding, :to => :processed
  end
  
  event :transcoding_error do
    transitions :from => :transcoding, :to => :error
  end
  
  # Returns mime-type of transcoding
  def content_type
    case video_codec
      when 'vp6'
      when 'flv'
        'video/x-flv'
    else
      'video/mpeg'
    end
  end
end
