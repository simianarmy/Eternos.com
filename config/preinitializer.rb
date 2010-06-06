# $Id$

# For Bundler 0.8
#require "#{File.dirname(__FILE__)}/../vendor/bundled_gems/environment"

# UNCOMMENT BELOW WHEN Bundler 0.9+ ACTUALLY WORKS
begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.20")
    raise RuntimeError, "Your bundler version is too old." +
     "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
end
