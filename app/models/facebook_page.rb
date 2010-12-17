class FacebookPage < ActiveRecord::Base
  serialize :page_data
  
  validates_presence_of :page_id
  validates_presence_of :name
  validates_presence_of :url
  validates_uniqueness_of :page_id
  
  # Attributes to ignore in the Facebooker::Page (or other page proxy) class
  IGNORE_PROXY_ATTRIBUTES = %W( session )
  
  # @@min_synch_delay
  # Set this to minimum amount of time between synchs for a single page
  cattr_accessor :min_synch_delay
  @@min_synch_delay = 1.hour
  
  # Creates new record from Facebooker::Page or some other object
  def self.create_from_proxy(fb_page)
    returning(self.new) do |klass|
      if validate_proxy(fb_page)
        Rails.logger.debug "Creating #{klass.class.to_s} from proxy object #{fb_page.inspect}"
        klass.page_id = fb_page.page_id
        klass.synch_with_proxy fb_page
      end
    end
  end
  
  def self.validate_proxy(fb_page)
    fb_page && fb_page.respond_to?(:page_id)
  end
  
  # Syncs existing object from proxy data
  def synch_with_proxy(fb_page)
    return false unless self.class.validate_proxy(fb_page) && (page_id == fb_page.page_id)
    return false if too_soon_since_last_synch?
    
    Rails.logger.debug "Synching with proxy object #{fb_page.inspect}"
    
    self.name = fb_page.name
    self.url  = fb_page.page_url
    
    # Save attributes as hash for serialization by using metaprogramming to 
    # find proxy object's attr_writer methods
    data = (fb_page.methods.grep(/\w=$/).map(&:chop) - IGNORE_PROXY_ATTRIBUTES).inject({}) do |res, attr|
      res[attr] = fb_page.send(attr) if fb_page.respond_to?(attr)
      res
    end
    self.page_data  = data
    self.save
  end
  
  def too_soon_since_last_synch?
    updated_at && ((Time.now.utc - updated_at) < min_synch_delay)
  end
  
  protected
  
  
end
