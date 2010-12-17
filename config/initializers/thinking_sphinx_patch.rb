module ThinkingSphinx
  # Attributes - eternally useful when it comes to filtering, sorting or
  # grouping. This class isn't really useful to you unless you're hacking
  # around with the internals of Thinking Sphinx - but hey, don't let that
  # stop you.
  #
  # One key thing to remember - if you're using the attribute manually to
  # generate SQL statements, you'll need to set the base model, and all the
  # associations. Which can get messy. Use Index.link!, it really helps.
  # 
  class Attribute < ThinkingSphinx::Property
    # ADDED THIS PATCH TO FIX CRASH WHEN IT CALLED to_i ON A DateTime OBJECT
    def sphinx_value(value)
      case value
      when TrueClass
        1
      when FalseClass, NilClass
        0
      when Time
        if value.respond_to?(:to_i)
          value.to_i
        else
          value.to_time.to_i
        end
      when Date
        value.to_time.to_i
      when String
        value.to_crc32
      else
        value
      end
    end
  end
end