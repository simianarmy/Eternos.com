# $Id$

module ActsAsAvAttachable
  def self.included(base)  
    base.send :extend, ClassMethods  
  end 
  
  module ClassMethods
    def acts_as_av_attachable
      has_one :av_attachment, :as => :av_attachable, :dependent => :destroy
      
      send :include, InstanceMethods
    end
  end 
  
  module  InstanceMethods
    def attached_recording
      av_attachment ? av_attachment.recording : nil
    end
    
    def recording_id=(recording_id)
      if rec = Recording.find(recording_id)
        self.recording = rec
      end
    end

    def recording=(recording)
      if new_record?
        build_av_attachment(:recording => recording)
      else
        create_av_attachment(:recording => recording)
      end
    end
     
  end
end

ActiveRecord::Base.send :include, ActsAsAvAttachable 
