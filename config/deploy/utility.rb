# For EngineYard backup software support.
# Eventually we will split these 2 packages so that backup doesn't have to load Rails env.

set :deploy_to, "/data/#{domain}"

role :app, '184.73.167.220'
role :web, '184.73.167.220'
role :db,  '184.73.167.220'

set :user, "deploy" 

set :rails_env, "production"

namespace :deploy do
  task :restart do
    #run "sudo monit restart workling"
  end
  
  task :start do
    # do nothing - override default
  end

  desc "Stops work daemons"
  task :stop_daemons, :roles => [:app] do
    run "sudo monit stop workling"
  end

  desc "Restarts any work daemons"
  task :start_daemons, :roles => [:app] do
    run "sudo monit start workling"
  end
  
  task :migrate, :roles => [:db] do
  end
end

#before "deploy:update_code", "deploy:stop_daemons"
after "deploy:symlink", "deploy:symlink_shared"
#after "deploy:symlink", "deploy:start_daemons"
#after "deploy:symlink_shared", "deploy:build_sphinx_index"
