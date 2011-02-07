module ActionView
  module Helpers
    module CaptureHelper
      # Allows one to use content_for-style methods repeatedly in views without
      # getting duplicate content in repeated invocations.
      def set_content_for(name, content = nil, &block)
        ivar = "@content_for_#{name}"
        instance_variable_set(ivar, nil)
        content_for(name, content, &block)
      end
    end
  end
end