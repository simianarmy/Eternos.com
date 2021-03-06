# $Id$

# For Bundler 0.8
#require "#{File.dirname(__FILE__)}/../vendor/bundled_gems/environment"


# WORKAROUND FOR CUSTOM APPS LOADING RAILS THAT ALREADY HAVE BUNDLER LOADED
unless defined? DaemonKit
  # CUSTOM FIX FOR PASSENGER
  # From http://tomafro.net/2009/11/a-rails-template-for-gem-bundler
  # CAUTION: MAY NOT WORK ON YOUR OS
  
  #require File.expand_path(File.join(File.dirname(__FILE__), "..", ".bundle", "environment"))

  begin
    require 'rubygems'
    require "bundler/setup"
  rescue LoadError
    raise "YOU'RE FUCKED!  BUNDLER HATES YOU!!!"
  end

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
    raise RuntimeError, "Your bundler version is too old." +
     "Run `gem install bundler` to upgrade."
  end

  begin
    # Set up load paths for all bundled gems
    #ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
    #Bundler.setup
    puts "*** Bundler.setup called with Gemfile at #{ENV["BUNDLE_GEMFILE"]}"
  rescue Bundler::GemNotFound
    raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
  end
  
else # defined? DaemonKit
  puts "*** Using DaemonKit!"
end
