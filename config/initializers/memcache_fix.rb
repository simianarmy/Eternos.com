# $Id$

# From http://www.mikeperham.com/2009/03/03/using-memcache-client-16x-in-rails-23/
# Using memcache-client 1.6.x in Rails < 2.3

# Actually using 1.7.4 now...

require 'rubygems'
 
# Brain surgery to use our own version of memcache-client without
# having to modify activesupport directly.
# Unload any previous instance of the class
if Object.const_defined? :MemCache
  Object.instance_eval { remove_const :MemCache }
end
# Pull in the exact version we want
gem 'memcache-client', '1.7.4'
# Ensure that the memcache-client path is at the front of the loadpath
$LOAD_PATH.each do |path|
  if path =~ /memcache-client/
    $LOAD_PATH.delete(path)
    $LOAD_PATH.unshift(path)
  end
end
# If Ruby thinks it's already loaded memcache.rb, force
# a reload otherwise just require.
if $".find { |file| file =~ /\Amemcache.rb\Z/ }
  load 'memcache.rb'
else
  require 'memcache'
end