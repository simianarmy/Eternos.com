# $Id$
# Production deploy recipes

set :deploy_to, "/var/www/#{domain}"

namespace :deploy do
  desc "Stops work daemons"
  task :stop_daemons, :roles => :app do
    run "god unmonitor eternos"
    run "god stop eternos-email-uploader"
    run "god stop eternos-workling"
  end

  desc "Restarts any work daemons"
  task :start_daemons, :roles => :app do
    run "cd #{current_path} && rake god:generate RAILS_ENV=#{stage}"
    run "god load #{current_path}/config/daemons.god"
    run "god restart eternos"
  end
end