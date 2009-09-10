# $Id$

require 'benchmark'
require 'workling_helper'

class RssWorker < Workling::Base
  include WorklingHelper
  
  # fetch rss item contents, take screen capture, and upload capture+thumb to S3
  def fetch_blog_contents(payload)
    logger.debug "RssWorker got payload #{payload.inspect}"
    entry = safe_find {
      FeedContent.find(payload[:id])
    }
    return unless entry
    begin
      #entry.save_html
      entry.save_screencap
    rescue
      logger.debug "Exception in RssWorker:fetch_blog_contents: " + $!
    end
  end
end
    