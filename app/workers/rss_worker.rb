# $Id$

require 'workling_helper'

class RssWorker < Workling::Base
  include WorklingHelper
  
  # fetch rss item contents, take screen capture, and upload capture+thumb to S3
  def fetch_blog_contents(payload)
    logger.info "#{self.class.to_s} got payload #{payload.inspect}"
    return unless entry = safe_find {
      FeedContent.find(payload[:id])
    }
    begin
      #entry.save_html
      entry.save_screencap
    rescue
      logger.error "Exception in RssWorker:fetch_blog_contents: " + $!
    end
  end
end
    