# $Id$

# ActiveRecord & MySQL monkey-patches to avoid deadlocks and other issues when using threads
# All from http://coderrr.wordpress.com/2009/01/08/activerecord-threading-issues-and-resolutions/

# For mysqlplus 
class Mysql
  alias_method :query, :c_async_query
end

# For catching 'server has gone away' & reconnecting
module ActiveRecord::ConnectionAdapters
  class MysqlAdapter
    alias_method :execute_without_retry, :execute unless
      method_defined?(:execute_without_retry)
    
    def execute(*args)      
      # Wrap with patched with_connection to ensure release of thread's connection
      # back to pool
      execute_without_retry(*args)
    rescue ActiveRecord::StatementInvalid
      if $!.message =~ /server has gone away/i
        warn "Server timed out, retrying"
        reconnect!
        retry
      end

      raise
    end
  end
end
 
class << Thread
  alias orig_new new
  def new
    orig_new do
      begin
        yield
      ensure
        puts "Releasing db connection in thread: #{self}"
        ActiveRecord::Base.connection_pool.release_connection
      end
    end
  end
end
