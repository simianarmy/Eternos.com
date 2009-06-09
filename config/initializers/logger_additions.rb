# $Id$
# config/initializers/logger_additions.rb
logger = ActiveRecord::Base.logger

# Call from model like this:
# logger.debug_variables(binding)
#
# Outputs all local & instance vars
# From  http://railscasts.com/episodes/86-logging-variables

def logger.debug_variables(bind)
  vars = eval('local_variables + instance_variables', bind)
  vars.each do |var|
    debug  "#{var} = #{eval(var, bind).inspect}"
  end
end
