# $Id$
#

# Encapsulates helper that can be included from controllers & models (and views too I guess)

# From using helpers in controller
# http://snippets.dzone.com/posts/show/1799
# Need to call number_helper ActionView method from within
# contents controller, reuse for other helper methods.

# Usage:
# From controller or model, call help.<method>

def help
  Helper.instance
end

class Helper
  include Singleton
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include DecorationsHelper
end


  