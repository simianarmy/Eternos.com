# $Id$

module FacebookHelper
  def facebook_name_or_login(user)
    facebook_session.user.name rescue user.login
  end
  
  def current_user_with_facebook
    facebook_session && facebook_session.user
  end
  
  def link_to_facebook_profile_sync(link_text, js_callback_func_name)
    link_to_remote link_text, :url => facebook_profile_path, :method => :get, 
      :complete => "EternosFB.facebook_profile_request_cb(request, #{js_callback_func_name})"
  end
  
  def sync_with_facebook_button(options = {})
    options[:controller] ||= "account_settings"
    options[:action] ||= "facebook_sync"
    options[:protocol] ||= 'https'
    
    fb_login_and_redirect(url_for(:controller => options[:controller], :action => options[:action], 
      :protocol => options[:protocol], :only_path => false),
      :size => :medium, :background => :white, :length => :short)
    
    #<a href="#" onclick="FB.Connect.requireSession(); return false;" class="fbconnect_login_button FBConnectButton FBConnectButton_Small"><span id="RES_ID_fb_login_text" class="FBConnectButton_Text">Sync with Facebook</span></a>
  end
end
