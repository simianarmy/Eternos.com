# $Id$

# Get loaded locales conveniently
# See http://rails-i18n.org/wiki/pages/i18n-available_locales
module I18n
  class << self
    def available_locales; backend.available_locales; end
  end
  module Backend
    class Simple
      def available_locales; translations.keys.collect { |l| l.to_s }.sort; end
    end
  end
end

# i18n configuration as specified in 
# http://rails-i18n.org/wiki/pages/i18n-rails-guide

# tell the I18n library where to find your translations
I18n.load_path += Dir[ File.join(RAILS_ROOT, 'config', 'locale', '*.{rb,yml}') ]

# you can omit this if you're happy with English as a default locale
# But...default is :en, we want :en-US ?
I18n.default_locale = "en-US" 

# You need to "force-initialize" loaded locales
I18n.backend.send(:init_translations)

AVAILABLE_LOCALES = I18n.backend.available_locales
RAILS_DEFAULT_LOGGER.debug "* Loaded locales: #{AVAILABLE_LOCALES.inspect}"