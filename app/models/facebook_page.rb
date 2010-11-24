class FacebookPage < ActiveRecord::Base
  serialize :page_data
  
  ValidProxies = %W( Facebooker::Page ) 
  
  # Creates new record from Facebooker::Page or some other object
  def self.create_from_proxy(fb_page)
    return unless validate_proxy(fb_page)
    Rails.logger.debug "Creating #{self.class.to_s} from proxy object #{fb_page.inspect}"
    
    obj = self.new(:page_id => fb_page.page_id,
      :name => fb_page.name,
      :url => fb_page.page_url)
    # Save all data into serialized column - it's always changing
    obj.page_data = fb_page.attributes
    obj.save
    obj
  end
  
  def self.validate_proxy(fb_page)
    fb_page && ValidProxies.include?(fb_page.class)
  end
  
  # Syncs existing object from proxy data
  def synch_with_proxy(fb_page)
    return unless self.class.validate_proxy(fb_page)
    Rails.logger.debug "Synching with proxy object #{fb_page.inspect}"
    
    self.page_name  = fb_page.name
    self.url        = fb_page.page_url
    self.page_data  = fb_page.attributes
    self.save
  end
  
  protected
  
  
end
