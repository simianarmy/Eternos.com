module EternosBackup
  # Wraps a specific source's error and provides 
  # convenience methods for viewing & resolving
  module BackupErrors
    # Pattern => code
    # Ordered by frequency descending, grouped by code
    # Negative codes are for program execution errors
    @@ErrorPatternsToCode = {
      # Facebook errors
      Regexp.new('Session key invalid or no longer valid')             => 100,
      Regexp.new('Cannot login to Facebook: no session key')           => 100,
      Regexp.new('Error logging in to Facebook: Incorrect signature')  => 102,
      Regexp.new('Error logging in to Facebook: undefined method')     => 103,
      Regexp.new('Error logging in to Facebook: Couldn\'t connect to server')  => 104,
      Regexp.new('Error logging in to Facebook: Invalid API key')      => 105,
      Regexp.new('Error fetching facebook friends\' wall posts')       => 106,
      Regexp.new('Error saving web albums: undefined method')          => 107,
      
      # Twitter errors
      Regexp.new('Twitter: (401): Unauthorized')                       => 200,
      Regexp.new('Twitter: (502): Proxy Error')                        => 201,
      
      # Rss errors
      
      # Email errors
      Regexp.new('Net::IMAP::NoResponseError: Invalid credentials')    => 400,
      
      # Program errors
      Regexp.new('undefined method')                                    => -100,
      Regexp.new('could not obtain a database connection within')       => -101 
    }
    
    @@UnknownErrorCode  = 0
    
    # Tries to match error string against pattern db to find error code
    def lookup_error_code(err)
      @@ErrorPatternsToCode.each do |rx,code|
        return code if rx =~ err
      end
      @@UnknownErrorCode
    end
  end
  
  class BackupSourceError
    include EternosBackup::BackupErrors
    
    attr_reader :source, :code
    delegate :description, :sent_error_alert, :to => :source
    
    def initialize(source)
      @source = source
      @code = lookup_error_code errors
    end
    
    def errors
      @errors ||= if source.auth_error
        source.auth_error
      elsif source.latest_backup
        errs = source.latest_backup.error_messages
        (errs.is_a? Array) ? errs.first : errs
      else
        'Unknown error'
      end
    end
    
    # Error message for humans
    def short_error
      backup_error_obj.description rescue 'Unknown error'
    end
    
    # Fix suggestions for humans
    def fix_suggestion
      backup_error_obj.fix_hint rescue 'Contact Support '
    end
    
    protected
    
    def backup_error_obj
      @backup_source_err ||= ::BackupErrorCode.find_by_code(@code)
    end
  end
end