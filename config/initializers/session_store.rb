# $Id$

# Required for Flash session cookie fix
# http://thewebfellas.com/blog/2008/12/22/flash-uploaders-rails-cookie-based-sessions-and-csrf-rack-middleware-to-the-rescue

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

ActionController::Base.session = {
  :key     => '_eternos.com_session',
  :secret  => '8ad163840e42b6893ad5c8ed99f6ee90db2fedb729963dd19447a53c3edeb00546ecd06e4a4cf1803542a2fe6f467f63c8a785825ed87adfe64d696586f1d0a1'
}

#ActionController::Dispatcher.middleware.insert_before(ActiveRecord::SessionStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
