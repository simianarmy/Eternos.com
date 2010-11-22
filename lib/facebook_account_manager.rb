# Module for managing multiple Facebook accounts per user

module FacebookAccountManager
  class << self
    # Load the session using the appropriate facebook account credentials
    def login_with_session(session, user, uid, session_key=nil, session_secret=nil)
      # Find credentials based on account id if none passed
      unless session_key 
        if acc = user.backup_sources.facebook.find_by_auth_login(uid)
          session_key = acc.auth_token
          session_secret = acc.auth_secret
        else
          session_key = user.facebook_session_key
          session_secret = user.facebook_secret_key
        end
      end
      if session_key
        session.connect(session_key, uid, nil, session_secret)
      end
    end
  end
end
