# $Id$
require 'rvideo'
 
module RVideo # :nodoc:
  module Tools # :nodoc:
    class AbstractTool
      module InstanceMethods
 
        alias :original_execute :execute
        def execute
          original_command = @command
          result = nil
          begin
            @command = "nice #{@command}"
            result = original_execute
          ensure
            @command = original_command
          end
          result
        end
      end
    end
  end
end
