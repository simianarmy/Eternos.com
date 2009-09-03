# $Id$

set :deploy_to, "/var/www/#{domain}_staging"

namespace :deploy do
  desc "Stops work daemons"
  task :stop_daemons, :roles => :app do
    puts "IMPLEMENT stop_daemons"
  end

  desc "Restarts any work daemons"
  task :start_daemons, :roles => :app do
    puts "IMPLEMENT start_daemons"
  end
end