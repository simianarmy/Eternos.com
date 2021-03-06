# $Id$

module ActsAsSavedToCloud
  def self.included(base)  
    base.send :extend, ActMethods  
  end 
  
  module ActMethods
    def acts_as_saved_to_cloud(opts={})
      include AfterCommit::ActiveRecord
      after_commit_on_create :start_upload
      
      acts_as_state_machine :initial => :pending
      
      state :pending
      state :staging, :enter => :upload
      state :processing
      state :complete, :enter => :uploaded
      state :upload_error

      event :start_cloud_upload do
        transitions :from => [:pending, :staging, :complete, :upload_error], :to => :processing
      end

      event :finish_cloud_upload do
        transitions :from => :processing, :to => :complete
      end

      event :processing_error do
        transitions :from => :processing, :to => :upload_error
      end

      event :stage do
        transitions :from => [:pending, :complete, :upload_error], :to => :staging
      end
      
      %w( state ).each do |col|
        raise "#{self.table_name} table must have a '#{col}' column" unless self.respond_to? col
      end
      
      extend ClassMethods
      include InstanceMethods
    end
  end 
  
  module ClassMethods
  end
  
  module  InstanceMethods
    def upload
      raise NoMethodError, "You must define a upload instance method in #{self.class}"
    end
    
    # Override this method in class to implement custom post-upload action
    def uploaded
      # NO OP
    end
    
    def cloud_upload_error(err)
      logger.debug "#{self.class}: error uploading to cloud: #{err}"
      processing_error!
    end
    
    protected
    
    def start_upload
      stage!
    end
  end
end

ActiveRecord::Base.send :include, ActsAsSavedToCloud 
