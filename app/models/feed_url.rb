# $Id$

# BackupSource STI class child

require 'feedzirra'

class FeedUrl < BackupSource
  validates_presence_of :rss_url, :message => "Please enter a RSS feed URL"
  validates_uniqueness_of :rss_url, :scope => :user_id, :message => "Feed has already been saved"
  validate :validate_feed
  
private  
  def validate_feed
    unless self.rss_url.blank?
      begin
        Feedzirra::Feed.fetch_and_parse(self.rss_url, :timeout => 30,
          :on_success => lambda { self.auth_confirmed = true },
          :on_failure => lambda { errors.add(:rss_url, "Invalid RSS feed")
          } )
      rescue Exception => e
        errors.add(:rss_url, "Invalid RSS feed (could not verify contents)")
      end
    end
  end
    # require 'rexml/document'
    #     require 'net/http'
    #     
    #     xml = REXML::Document.new Net::HTTP.get(URI.parse(self.url))
    #     data = {
    #       :title    => xml.root.elements['channel/title'].text,
    #       :home_url => xml.root.elements['channel/link'].text,
    #       :rss_url  => self.url,
    #       :items    => []
    #     }
    #     xml.elements.each '//item' do |item|
    #       new_items = {} and item.elements.each do |e|
    #         new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
    #       end
    #       data[:items] << new_items
    #     end
    #     return true if data
    #   rescue
    #     return false
    #   end
end
