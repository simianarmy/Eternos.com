# $Id$

#require File.join(File.dirname(__FILE__), '/../class_level_inheritable_attributes')
# See http://www.raulparolari.com/Rails/class_inheritable if you want to duplicate
# active_support's class_inheritable_accessor ... not worth the effort since we're 
# loading the Rails env later.
require 'active_support' # for class_inheritable_accessor
require File.join(RAILS_ROOT, 'lib/eternos_backup/site_data')

module BackupWorker    
  # Base class for all site-specific worker classes
  class Base
    class BackupIncomplete < Exception; end
    
    #include BackupDaemonHelper # For logger
    # not needed if we're using active_support
    #include ClassLevelInheritableAttributes
    
    class_inheritable_accessor :site, :actions
    
    attr_reader :backup_job, :backup_source, :errors
    
    ConsecutiveRequestDelaySeconds = 2
    
    self.site    = 'base'
    self.actions = []
    #cattr_reader :dbsync_mutex
    #@@dbsync_mutex = Mutex.new
    
    def initialize(backup_job)
      @backup_job     = backup_job
      @backup_source  = backup_job.backup_source
      @errors         = []
      @run_actions    = []
    end
    
    # Implement in child classes
    def authenticate
      false
    end
    
    # Runs child class actions 
    def run(options={})
      opts = {}
      opts.merge!(options) if options
      
      # Run actions in random order, using EM reactor queue to schedule actions
      @run_actions = get_dataset_actions(opts).sort_by { rand }
      #log_debug "ACTIONS TO RUN: #{@run_actions.join(' ')}"
      @run_actions.each do |action| 
        send("save_#{action}", opts)
        # We can sleep safely if we are in a real thread
        pause
      end
    end
    
    def update_completion_counter(step=increment_step)
      backup_job.increment!(:percent_complete, step) unless backup_job.percent_complete >= 100
    end

    def set_completion_counter(val=100)
      backup_job.update_attribute(:percent_complete, val)
    end

    protected

    def member
      backup_source.member
    end
    
    # Returns dataset-specific actions to perform
    def get_dataset_actions(options)
      ds = get_dataset(options)
      if self.actions.has_key?(ds)
        self.actions[ds]
      else
        self.actions[EternosBackup::SiteData.defaultDataSet]
      end
    end
    
    # Returns data set value from workitem options hash, if any, otherwise returns default
    def get_dataset(options)
      if options.nil? || !options.is_a?(Hash) || !options.has_key?('dataType')
        return EternosBackup::SiteData.defaultDataSet
      else
        options['dataType']
      end
    end
    
    # Calculates completion step value per action
    def increment_step
      100 / [@run_actions.size, 1].max
    end
    
    def save_error(err)
      log :error, err
      @errors << err
    end
    
    def save_exception(msg, e)
      save_error "#{msg}: #{e.to_s} #{e.backtrace}"
      log :error, e.backtrace
    end
  
    # non-blocking sleep - only call sleep() if in worker thread
    def pause(ticks=ConsecutiveRequestDelaySeconds)
      if Thread.current != Thread.main
        log_debug "Thread #{Thread.current} sleeping for #{ticks} ticks..."
        sleep(ticks) 
      end
    end
  end
end

