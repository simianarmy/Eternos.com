# $Id$

# ActiveRecord & MySQL monkey-patches to avoid deadlocks and other issues when using threads
# All from http://coderrr.wordpress.com/2009/01/08/activerecord-threading-issues-and-resolutions/

# For catching 'server has gone away' & reconnecting
# Do we need this now that Rails 2.3 supports retry flag??
module ActiveRecord::ConnectionAdapters
  class MysqlAdapter
    alias_method :execute_without_retry, :execute unless
      method_defined?(:execute_without_retry)
    
    def execute(*args)      
      # Wrap with patched with_connection to ensure release of thread's connection
      # back to pool
      execute_without_retry(*args)
    rescue ActiveRecord::StatementInvalid
      if ($!.message =~ /server has gone away/i) ||
        ($!.message =~ /Lost connection to MySQL server during query/i)
        warn "Mysql error: " + $!.message + ", retrying"
        reconnect!
        retry
      end
      
      raise
    end
  end
end
 

