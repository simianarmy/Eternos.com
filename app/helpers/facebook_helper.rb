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
end
