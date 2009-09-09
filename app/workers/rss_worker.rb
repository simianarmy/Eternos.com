# $Id$

require 'benchmark'

class RssWorker < Workling::Base
  # fetch rss item contents, take screen capture, and upload capture+thumb to S3
  def fetch_blog_contents(payload)
    logger.debug "RssWorker got payload #{payload.inspect}"
    begin
      entry = FeedContent.find(payload[:id])
    rescue ActiveRecord::StatementInvalid => e
      # Catch mysql has gone away errors
      if e.to_s =~ /away/
        ActiveRecord::Base.connection.reconnect! 
        retry
      end
    rescue
      logger.debug $!.to_s
      return
    end
    
    begin
      entry.save_html
      entry.save_screencap
    rescue
      logger.debug "Exception in RssWorker:fetch_blog_contents: " + $!
    end
  end
end
    