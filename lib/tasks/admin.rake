# $Id$
# lib/tasks/deadweight.rake
begin
  require 'deadweight'
rescue LoadError
end

namespace :admin do
  desc "Count total active accounts (with backup data & total)"
  task :member_count => :environment do
    puts Member.active.with_data.size.to_s + " / " + Member.active.size.to_s
  end
  
  desc "run Deadweight CSS check (requires script/server)"
  Deadweight::RakeTask.new do |dw|
    dw.mechanize = true
    dw.root = 'http://dev.eternos.com'
    dw.stylesheets = %w( /stylesheets/application.css /stylesheets/screen.css /stylesheets/new_design/style.css 
      /stylesheets/featureList.css /stylesheets/new_design/styleie7.css /stylesheets/new_design/styleie6.css)
    dw.pages = ["/", "/about", "/about/what", "/about/contact", "/about/press", "/about/careers", 
      "/about/terms", "/about/privacy", "/password_resets/new", "/account/plans", 
      "/account/new?plan=Free"]
    dw.pages << proc {
      fetch("/signup/create")
      fetch("/user_sessions")
    }
    dw.ignore_selectors = /flash_notice|flash_error|errorExplanation|fieldWithErrors/
    puts dw.run
  end
end