# $Id$

namespace :admin do
  desc "Count total active accounts (with backup data & total)"
  task :member_count => :environment do
    puts Member.active.with_data.size.to_s + " / " + Member.active.size.to_s
  end
end