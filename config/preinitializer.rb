# $Id$

# Rails 2.3+ initializer

$stderr.puts 'Updating bundled gems...'
system 'gem bundle --cached'
require "#{RAILS_ROOT}/vendor/bundled_gems/environment"
