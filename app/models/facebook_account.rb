# BackupSource STI class representing a Facebook account

class FacebookAccount < BackupSource
  has_many :facebook_page_admins
  has_many :pages, :through =>:facebook_page_admins, :source => :facebook_page
  
  alias_attribute :account_id, :auth_login
  
  def set_facebook_session_keys(session_key, secret_key='')
    self.auth_token  = session_key
    self.auth_secret = secret_key
    save(false)
  end
  
  def reset_authorization
    self.auth_confirmed = false
    set_facebook_session_keys(nil, nil)
  end
  
  # Takes array of Facebooker::Page objects and saves page and relationship
  def save_administered_pages(admined_pages)
    return unless admined_pages && admined_pages.respond_to?(:each)
    admined_pages.each do |p|
      if fb_page = pages.find_by_page_id(p.page_id)
        fb_page.synch_with_proxy(p)
      else
        pages << FacebookPage.create_from_proxy(p)
      end
    end
  end    
end