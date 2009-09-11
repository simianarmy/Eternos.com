# $Id$

require 'screen_capture'
require 's3_helper'

class FeedContent < ActiveRecord::Base
  include AfterCommit::ActiveRecord

  belongs_to :feed_entry
  has_attached_file :screencap, 
  :styles => { :thumb => "300x300" },
  :storage => :s3,
  :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
  :url => ":class/:id/:basename_:style.:extension",
  :path => ":class/:id/:basename_:style.:extension",
  :bucket => S3Buckets::ScreencapBucket.eternos_bucket_name
    
  def save_html
    c = Curl::Easy.perform(feed_entry.url)
    self.update_attribute(:html_content, c.body_str) unless c.body_str.blank?
  end

  # Take screecapture of site & saves image file
  def save_screencap
    if (s = ScreenCapture.capture(feed_entry.url)) && File.exist?(s)
      self.screencap = File.new(s)
      self.save # save to start s3 upload
      File.delete(s)
    end
  end

  def screencap_url
    return_unless_missing(screencap.url)
  end
  
  def screencap_thumb_url
    return_unless_missing(screencap.url(:thumb))
  end
  
  protected

  def after_commit_on_create
    logger.debug "Sending job to rss worker: #{self.id}"
    RssWorker.async_fetch_blog_contents(:id => self.id) if self.feed_entry.url
  end
  
  def return_unless_missing(url)
    url.match(/missing/) ? '' : url
  end
end