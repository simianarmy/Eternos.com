# $Id$

module WorklingHelper
  # Performs activerecord operation in begin/rescue statement to handle 
  # mysql disconnection or record not found errors
  def safe_find
    begin
      yield
    rescue ActiveRecord::StatementInvalid => e
      # Catch mysql has gone away errors
      if e.to_s =~ /away/
        ActiveRecord::Base.connection.reconnect! 
        retry
      end
    rescue
      RAILS_DEFAULT_LOGGER.warn $!.to_s
      nil
    end
  end
end