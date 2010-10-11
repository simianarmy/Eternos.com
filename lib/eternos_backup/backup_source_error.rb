module EternosBackup
  # Wraps a specific source's error and provides 
  # convenience methods for viewing & resolving
  module BackupErrors
    
  end
  
  class BackupSourceError
    attr_reader :source
    delegate :description => :source
    
    def initialize(source)
      @source = source
    end
    
    def errors
      @errors ||= if source.auth_error
        source.auth_error
      elsif source.latest_backup
        source.latest_backup.error_messages
      else
        ['Unknown error']
      end
    end
    
    # Error message for humans
    def short_error
      @errors.first
    end
    
    # Error code for non-humans
    def error_code
      # TODO: IMPLEMENT ME
    end
    
    # Full error string for debugging, analysis
    def error_full
      @errors.join(', ')
    end
    
    # Fix suggestions for humans
    def fix_suggestion
      # TODO: IMPLEMENT ME
    end
  end
end