# $Id$
# Production deploy recipes

set :deploy_to, "/var/www/#{domain}"
set :user, "deploy" 

role :app, "184.106.217.211"
role :web, "184.106.217.211"
role :db, "184.106.217.211", :primary => true

set :bundle_cmd, "/usr/local/bin/bundle"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

#before "deploy:update_code", "deploy:stop_daemons"
#after "deploy:symlink_shared", "deploy:minify_js"
after "deploy:symlink", "deploy:publish_robots_file"
#after "deploy:symlink", "deploy:google_analytics"
#after "deploy:symlink", "deploy:cleanup" # Messes with backup daemons
#after "deploy:symlink", "deploy:update_crontab"

after "deploy:symlink", "deploy:symlink_shared"
#after "deploy:symlink_shared", "deploy:build_sphinx_index"
#after "deploy:symlink", "deploy:start_daemons"
#after "deploy:symlink", "deploy:sendmail"
#after "deploy:symlink", "deploy:install_sitemaps"