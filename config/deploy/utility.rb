# For EngineYard backup software support.
# Eventually we will split these 2 packages so that backup doesn't have to load Rails env.

set :deploy_to, "/data/#{domain}"

role :app, '184.73.167.220'
role :web, '184.73.167.220'
role :db,  '184.73.167.220'

set :user, "deploy" 
set :rails_env, "production"

namespace :deploy do
  task :start do
    # do nothing - override default
  end

  desc "Stops work daemons"
  task :stop_daemons, :roles => [:app] do
    #thinking_sphinx.stop
    #run "god stop eternos_#{stage}"
    # Try to prevent too many worklings god/deploy bug
    #run "god unmonitor eternos-workling_#{stage}"
  end

  desc "Restarts any work daemons"
  task :start_daemons, :roles => [:app] do
    #run "cd #{current_path} && rake god:generate RAILS_ENV=#{stage}"
    #run "RAILS_ENV=#{stage} god load #{current_path}/config/daemons.god"
    #run "RAILS_ENV=#{stage} god start eternos_#{stage}"
  end
  
  task :migrate, :roles => [:db] do
  end
end

after "deploy:symlink", "deploy:symlink_shared"
#after "deploy:symlink_shared", "deploy:build_sphinx_index"
