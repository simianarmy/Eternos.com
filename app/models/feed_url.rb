class FeedUrl < ActiveRecord::Base
  belongs_to :profile
  
  validate do |feed|
    feed.errors.add("", "Please enter a URL") if feed.url.blank?
  end
  
  validate :validate_rss_feed
  
  def validate_rss_feed
    errors.add("", "Invalid RSS feed URL") unless parse_rss_feed?
  end
  
private  
  def parse_rss_feed?
    require 'rexml/document'
    require 'net/http'
    
    xml = REXML::Document.new Net::HTTP.get(URI.parse(self.url))
    data = {
      :title    => xml.root.elements['channel/title'].text,
      :home_url => xml.root.elements['channel/link'].text,
      :rss_url  => self.url,
      :items    => []
    }
    xml.elements.each '//item' do |item|
      new_items = {} and item.elements.each do |e|
        new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
      end
      data[:items] << new_items
    end
    return true if data
  rescue
    return false
  end
end
