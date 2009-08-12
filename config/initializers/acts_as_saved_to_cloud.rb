# $Id$

module ActsAsSavedToCloud
  def self.included(base)  
    base.send :extend, ActMethods  
  end 
  
  module ActMethods
    def acts_as_saved_to_cloud(opts={})
      acts_as_state_machine :initial => :pending
      
      state :pending
      state :staging, :enter => :upload
      state :processing
      state :complete
      state :upload_error

      event :start_cloud_upload do
        transitions :from => :staging, :to => :processing
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
      
      raise "#{self.table_name} table must have a 'state' column" unless self.respond_to? :state
      
      extend ClassMethods
      include AfterCommit::ActiveRecord
      include InstanceMethods
    end
  end 
  
  module ClassMethods
  end
  
  module  InstanceMethods
    def upload
      raise NoMethodError, "You must define a upload instance method in #{self.class}"
    end
    
    def cloud_upload_error(err)
      update_attribute(:upload_error, err)
      processing_error!
    end
    
    protected
    
    def after_commit_on_create
      stage!
    end
  end
end

ActiveRecord::Base.send :include, ActsAsSavedToCloud 
